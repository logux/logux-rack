# frozen_string_literal: true

module Logux
  module Process
    class Auth
      attr_reader :stream, :chunk

      def initialize(stream:, chunk:)
        @stream = stream
        @chunk = chunk
      end

      def call
        stream.write([auth_result, chunk.auth_id])
      end

      AUTHENTICATED = 'authenticated'
      DENIED = 'denied'

      private

      def auth_result
        auth_rule(chunk.user_id, chunk.credentials) ? AUTHENTICATED : DENIED
      end

      def auth_rule(user_id, credentials)
        Logux.configuration.auth_rule.call(user_id, credentials)
      end
    end
  end
end
