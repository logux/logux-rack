# frozen_string_literal: true

module Policies
  module Channels
    class Users < Logux::Policy
      def subscribe?
        raise StandardError, headers['error'] if headers['error'].present?
        params = { user_id: action.channel.split('/')[1] }
        user_id = meta.id.split[1].split(':')[0]
        params[:user_id] == user_id
      end
    end
  end
end
