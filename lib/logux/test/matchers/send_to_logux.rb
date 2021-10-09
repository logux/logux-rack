# frozen_string_literal: true

require_relative 'base'

module Logux
  module Test
    module Matchers
      class SendToLogux < Base
        def matches?(actual)
          @difference = state_changes_inside { actual.call }
          return !@difference.empty? if expected.empty?

          expected.all? do |expected|
            @difference.find do |state|
              state['commands'].any? { |command| match_commands?(command, expected) }
            end
          end
        end

        def failure_message
          "expected that #{pretty(@difference)} to include commands #{pretty(expected)}"
        end

        private

        def state_changes_inside
          before_state = Logux::Test::Store.instance.data.dup
          yield
          after_state = Logux::Test::Store.instance.data
          (after_state - before_state).map { |d| JSON.parse(d) }
        end

        def match_commands?(stored_command, expected_command)
          expected_command.each_pair.all? do |key, part|
            part.stringify_keys! if part.is_a?(Hash)
            matcher(part).matches?(stored_command[key.to_s])
          end
        end

        def matcher(part)
          return part if part.is_a?(RSpec::Matchers::BuiltIn::BaseMatcher)
          RSpec::Matchers::BuiltIn::Eq.new(part)
        end
      end
    end
  end
end
