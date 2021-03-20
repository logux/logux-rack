# frozen_string_literal: true

module Logux
  class Policy
    class UnauthorizedError < StandardError; end

    attr_reader :action, :meta, :headers

    def initialize(action:, meta:, headers:)
      @action = action
      @meta = meta
      @headers = headers
    end

    def user_id
      @user_id ||= meta.user_id
    end
  end
end
