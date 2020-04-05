# frozen_string_literal: true

module Actions
  class Comment < Logux::ActionController
    def add
      resend channels: 'users'
      respond :processed
    end
  end
end
