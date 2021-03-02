# frozen_string_literal: true

require 'semantic_range'

module Logux
  module Process
    class Auth
      attr_reader :stream, :chunk

      def initialize(stream:, chunk:)
        @stream = stream
        @chunk = chunk
      end

      def call
        valid_subprotocol
        try_to_auth
      end

      AUTHENTICATED = 'authenticated'
      DENIED = 'denied'
      WRONG_SUBPROTOCOL = 'wrongSubprotocol'
      ERROR = 'error'

      def stop_process?
        @stop_process ||= false
      end

      private

      def try_to_auth
        return if stop_process?
        stream.write({ answer: auth_result, subprotocol: chunk.subprotocol, authId: chunk.auth_id })
      end

      def valid_subprotocol
        unless SemanticRange.satisfies?(chunk.subprotocol, Logux.configuration.supports)
          @stop_process = true
          stream.write({ answer: WRONG_SUBPROTOCOL, authId: chunk.auth_id, supported: Logux.configuration.supports })
        end
      end

      def auth_result
        auth_rule(chunk.user_id, chunk.token, chunk.cookie, chunk.headers) ? AUTHENTICATED : DENIED
      end

      def auth_rule(user_id, token, cookie, headers)
        Logux.configuration.auth_rule.call(user_id, token, cookie, headers)
      end
    end
  end
end
