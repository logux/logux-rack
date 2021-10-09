# frozen_string_literal: true

module Logux
  class ActionWatcher
    def self.call(options = {}, &block)
      new(options).call(&block)
    end

    attr_reader :options

    def initialize(options = {})
      raise ArgumentError, :options unless options.is_a?(Hash)
      @options = options
    end

    def call
      yield
    end
  end
end
