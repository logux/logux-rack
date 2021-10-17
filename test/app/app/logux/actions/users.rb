# frozen_string_literal: true

module Actions
  class Users < Logux::ActionController
    resend :name, ->(action) { { channels: ["users/#{action['payload']['userId']}"] } }

    def name
      update_user_name(User.find(action['payload']['userId']))
      respond :processed
    end

    def clean
      User.all.each do |user|
        user.update(name: '')

        send_back(
          {
            type: 'users/name',
            payload: { userId: user.id.to_s, name: user.name }
          }
        )
      end
    end

    private

    def update_user_name(user)
      old_meta = user.last_changed ? JSON.parse(user.last_changed) : nil
      return unless Logux::IsFirstOlder.new(old_meta, meta).call
      user.update!(name: action['payload']['name'], last_changed: meta.to_json)
    end
  end
end
