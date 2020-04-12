# frozen_string_literal: true

module Actions
  class Comment < Logux::ActionController
    resend :add, channel: :users

    def add
      respond :processed
    end
  end
end
