# frozen_string_literal: true

module Logux
  class Auth
    attr_reader :user_id, :credentials, :auth_id

    def initialize(user_id:, credentials:, auth_id:)
      @user_id = user_id
      @credentials = credentials
      @auth_id = auth_id
    end
  end
end
