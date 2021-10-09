# frozen_string_literal: true

module Logux
  class Auth
    attr_reader :user_id, :token, :auth_id, :subprotocol, :headers, :cookie

    def initialize(user_id:, token:, cookie:, auth_id:, subprotocol:, headers:)
      @user_id = user_id
      @token = token
      @cookie = cookie
      @auth_id = auth_id
      @subprotocol = subprotocol
      @headers = headers
    end
  end
end
