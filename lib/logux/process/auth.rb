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

        stream.write(
          answer: auth_result,
          subprotocol: chunk.subprotocol,
          authId: chunk.auth_id
        )
      end

      def valid_subprotocol
        return if subprotocol_supported?
        @stop_process = true

        stream.write(
          answer: WRONG_SUBPROTOCOL,
          authId: chunk.auth_id,
          supported: Logux.configuration.supports
        )
      end

      def subprotocol_supported?
        SemanticRange.satisfies?(chunk.subprotocol, Logux.configuration.supports)
      end

      def auth_result
        return AUTHENTICATED if auth_rule?
        DENIED
      end

      def auth_rule?
        Logux.configuration.auth_rule.call(chunk.user_id, chunk.token, chunk.cookie, chunk.headers)
      end
    end
  end
end
