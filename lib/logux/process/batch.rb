# frozen_string_literal: true

module Logux
  module Process
    class Batch
      attr_reader :stream, :batch

      def initialize(stream:, batch:)
        @stream = stream
        @batch = batch
      end

      def call
        last_chunk = batch.size - 1
        preprocessed_batch.map.with_index do |chunk, index|
          begin
            case chunk[:type]
            when :action
              process_action(chunk: chunk.slice(:action, :meta, :headers))
            when :auth
              process_auth(chunk: chunk[:auth])
            end
          rescue => e
            handle_action_processing_errors(stream, e, chunk[:meta] ? chunk[:meta]['id'] : nil)
          end
          stream.write(',') if index != last_chunk
        end
      end

      def handle_action_processing_errors(logux_stream, exception, id)
        Logux.configuration.on_error&.call(exception)
        Logux.logger.error("#{exception}\n#{exception.backtrace.join("\n")}")
      ensure
        logux_stream.write({ id: id }.merge(Logux::ErrorRenderer.new(exception).message))
      end

      def process_action(chunk:)
        Logux::Process::Action.new(stream: stream, chunk: chunk).call
      end

      def process_auth(chunk:)
        Logux::Process::Auth.new(stream: stream, chunk: chunk).call
      end

      def preprocessed_batch
        @preprocessed_batch ||= batch.map do |chunk|
          case chunk['command']
          when 'action'
            preprocess_action(chunk)
          when 'auth'
            preprocess_auth(chunk)
          end
        end
      end

      def preprocess_action(chunk)
        { type: :action,
          action: Logux::Action.new(chunk['action']),
          meta: Logux::Meta.new(chunk['meta']),
          headers: chunk['headers'] }
      end

      def preprocess_auth(chunk)
        { type: :auth,
          auth: Logux::Auth.new(user_id: chunk['userId'],
                                auth_id: chunk['authId'],
                                subprotocol: chunk['subprotocol'],
                                token: chunk['token'],
                                cookie: chunk['cookie'],
                                headers: chunk['headers']) }
      end
    end
  end
end
