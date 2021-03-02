# frozen_string_literal: true

module Logux
  module Rack
    LOGUX_ROOT_PATH = '/logux'

    class App < Sinatra::Base
      ERROR = {
        attempts: 'Too many wrong secret attempts',
        secret: 'Wrong secret',
        protocol: 'Back-end protocol version is not supported',
        body: 'Wrong body'
      }.freeze

      before do
        request.body.rewind
        content_type 'application/json'
      end

      post LOGUX_ROOT_PATH do
        begin
          validate_request!
          stream { |out| build_response(out) }
        rescue JSON::ParserError
          halt(400, ERROR[:body])
        end
      end

      private

      # rubocop:disable Metrics/LineLength
      def validate_request!
        halt(429, ERROR[:attempts]) unless Logux.throttle.allow_request(request_ip)
        halt(400, ERROR[:body]) unless Logux.valid_body?(logux_params)
        check_secret
        halt(400, ERROR[:protocol]) unless Logux.valid_protocol?(meta_params)
        true
      end
      # rubocop:enable Metrics/LineLength

      def check_secret
        if Logux.valid_secret?(meta_params)
          Logux.throttle.clear(request_ip)
        else
          Logux.throttle.remember_bad_auth(request_ip, Time.now.to_i)
          halt(403, ERROR[:secret])
        end
      end

      def build_response(out)
        logux_stream = Logux::Stream.new(out)
        logux_stream.write('[')
        Logux.process_batch(stream: logux_stream, batch: command_params)
        logux_stream.write(']')
      end

      def logux_params
        @logux_params ||= JSON.parse(request.body.read)
      end

      def command_params
        logux_params['commands'] || []
      end

      def request_ip
        @request_ip ||= request.ip
      end

      def meta_params
        logux_params&.slice('version', 'secret', 'id')
      end
    end
  end

  def self.application
    Logux::Rack::App
  end
end
