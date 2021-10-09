# frozen_string_literal: true

module Logux
  class ActionController < Logux::BaseController
    class << self
      def resend(action_type, receivers)
        resend_targets[action_type.to_s] = receivers
      end

      def receivers_by_action(action_type, action)
        receivers = resend_targets[action_type.split('/').last.to_s]
        return receivers unless receivers.respond_to?(:call)
        receivers.call(action)
      end

      def resend_targets
        @resend_targets ||= {}
      end
    end
  end
end
