# frozen_string_literal: true

module Policies
  module Actions
    class Users < Logux::Policy
      def name?
        raise StandardError, headers['error'] if headers && headers['error'].present?

        user_id = meta.id.split(' ')[1].split(':')[0]
        action['payload']['userId'] == user_id
      end

      def clean?
        true
      end
    end
  end
end
