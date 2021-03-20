# frozen_string_literal: true

module Logux
  class PolicyCaller
    extend Forwardable

    attr_reader :action, :meta, :headers

    def_delegators :Logux, :logger, :configuration

    def initialize(action:, meta:, headers:)
      @action = action
      @meta = meta
      @headers = headers
    end

    def call!
      logger.debug('Searching policy for Logux action:' \
                   " #{action}, meta: #{meta}")
      policy.public_send("#{action.action_type}?")
    rescue Logux::UnknownActionError, Logux::UnknownChannelError => e
      raise e if configuration.verify_authorized

      logger.warn(e)
    end

    private

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(action: action,
                                               meta: meta,
                                               headers: headers)
    end

    def policy
      class_finder.find_policy_class.new(action: action,
                                         meta: meta,
                                         headers: headers)
    end
  end
end
