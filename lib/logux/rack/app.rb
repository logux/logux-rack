# frozen_string_literal: true

module Logux
  module Rack
    LOGUX_ROOT_PATH = '/logux'

    class App < Sinatra::Base
      before do
        request.body.rewind
        content_type 'application/json'
      end

      post LOGUX_ROOT_PATH do
        halt(403, 'Wrong secret') unless Logux.verify_request_meta_data(meta_params)
        halt(400, 'Back-end protocol version is not supported') unless Logux.verify_protocol(meta_params)

        stream do |out|
          begin
            logux_stream = Logux::Stream.new(out)
            logux_stream.write('[')
              Logux.process_batch(stream: logux_stream, batch: command_params)
          rescue => e
            handle_action_processing_errors(logux_stream, e)
          ensure
            logux_stream.write(']')
          end
        end
      end

      private

      def logux_params
        @logux_params ||= JSON.parse(request.body.read)
      end

      def command_params
        logux_params.dig('commands') || []
      end

      def meta_params
        logux_params&.slice('version', 'secret')
      end

      def handle_action_processing_errors(logux_stream, exception)
        Logux.configuration.on_error&.call(exception)
        Logux.logger.error("#{exception}\n#{exception.backtrace.join("\n")}")
      ensure
        logux_stream.write(Logux::ErrorRenderer.new(exception).message)
      end
    end
  end

  def self.application
    Logux::Rack::App
  end
end
