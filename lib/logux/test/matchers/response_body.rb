# frozen_string_literal: true

require_relative 'base'

module Logux
  module Test
    module Matchers
      class ResponseBody < Base
        def initialize(body)
          @body = body
        end

        def matches?(actual)
          @actual = actual
          actual.body == body
        end

        def failure_message
          "expected that '#{actual.body}' to equal '#{body}'"
        end

        private

        attr_reader :body, :actual
      end
    end
  end
end
