# frozen_string_literal: true

module Channels
  class Users < Logux::ChannelController
    def subscribe
      @user = User.find_or_initialize_by(id: user_id)
      if @user.new_record?
        @user.name = 'Name'
        @user.save
      end
      super
    end

    def initial_data
      [{
        type: 'users/name',
        payload: { userId: @user.id.to_s, name: @user.name }
      }]
    end
  end
end
