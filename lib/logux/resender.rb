# frozen_string_literal: true

module Logux
  class Resender
    extend Forwardable

    attr_reader :action, :meta, :headers

    def_delegators :Logux, :logger

    def initialize(action:, meta:, headers:)
      @action = action
      @meta = meta
      @headers = headers
    end

    def call!
      return nil unless any_receivers?
      return nil unless receivers_for_action?
      { answer: 'resend', id: meta['id'] }.merge(receivers_for_action)
    rescue Logux::UnknownActionError, Logux::UnknownChannelError => e
      logger.warn(e)
      nil
    end

    private

    def any_receivers?
      return true if action_class.respond_to? :receivers_by_action
      false
    end

    def receivers_for_action?
      return true if receivers_for_action.present?
      false
    end

    def receivers_for_action
      @receivers_for_action ||= action_class.receivers_by_action(action.type, action)
    end

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(action: action, meta: meta, headers: headers)
    end

    def action_class
      @action_class ||= class_finder.find_action_class
    end
  end
end
