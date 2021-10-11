# frozen_string_literal: true

require_relative 'base'

module Logux
  module Test
    module Matchers
      class ResponseBody < Base
        def initialize(body)
          @body = body
          @actual_body = nil
        end

        def matches?(actual)
          @actual_body = actual.body
          if actual.headers['rack.hijack']
            io = ::Logux::Test::StreamIO.new
            actual.headers['rack.hijack'].call(io)
            io.rewind
            @actual_body = JSON.parse(io.read)
          end
          @actual_body == body
        end

        def failure_message
          "expected that '#{@actual_body}' to equal '#{body}'"
        end

        private

        attr_reader :body, :actual
      end
    end
  end
end
