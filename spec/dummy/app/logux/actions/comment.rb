# frozen_string_literal: true

module Actions
  class Comment < Logux::ActionController
    resend_receivers :add, channel: :users

    def add
      respond :processed
    end
  end
end
