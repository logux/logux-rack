# frozen_string_literal: true

module Logux
  class ActionCaller
    extend Forwardable

    attr_reader :action, :meta

    def_delegator :Logux, :logger

    def initialize(action:, meta:)
      @action = action
      @meta = meta
    end

    def call!
      call_action
    rescue Logux::UnknownActionError, Logux::UnknownChannelError => e
      logger.warn(e)
      format(nil)
    end

    protected

    def call_action
      logger.debug("Searching Logux action: #{action}, meta: #{meta}")
      format(action_controller.public_send(action.action_type))
    end

    private

    def format(response)
      return response if response.is_a?(Logux::Response)

      Logux::Response.new(:processed, action: action, meta: meta)
    end

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(action: action, meta: meta)
    end

    def action_controller
      class_finder.find_action_class.new(action: action, meta: meta)
    end
  end
end
