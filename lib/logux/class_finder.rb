# frozen_string_literal: true

module Logux
  class ClassFinder
    include Logux::Utils

    attr_reader :action, :meta, :headers

    def initialize(action:, meta:, headers:)
      @action = action
      @meta = meta
      @headers = headers
    end

    def find_action_class
      "#{class_namespace}::#{class_name}".constantize
    rescue NameError
      raise_error_for_missing('action')
    end

    def find_policy_class
      "Policies::#{class_namespace}::#{class_name}".constantize
    rescue NameError
      raise_error_for_missing('policy')
    end

    def class_name
      return action.channel_name.camelize if subscribe?
      name = action.type.split('/')[0..-2]
      name.present? ? name.map(&:camelize).join('::') : action.type.camelize
    end

    private

    def class_namespace
      subscribe? ? 'Channels' : 'Actions'
    end

    def subscribe?
      action.type == 'logux/subscribe'
    end

    def action?
      !subscribe?
    end

    def class_path
      underscore("#{class_namespace}::#{class_name}")
    end

    def raise_error_for_missing(subject)
      message = error_message(subject)
      raise error_class.new(message, meta: meta)
    end

    def error_class
      action? ? UnknownActionError : UnknownChannelError
    end

    def error_message(subject)
      path = "app/logux/#{class_namespace.downcase}/#{class_path}.rb"
      "#{subject} '#{class_name.camelize}'not found at '#{path}'"
    end
  end
end
