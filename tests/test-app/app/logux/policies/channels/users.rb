# frozen_string_literal: true

module Policies
  module Channels
    class Users < Logux::Policy
      # rubocop:disable Metrics/AbcSize
      def subscribe?
        raise StandardError, headers['error'] if headers['error'].present?
        params = { user_id: action.channel.split('/')[1] }
        user_id = meta.id.split[1].split(':')[0]
        params[:user_id] == user_id
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
