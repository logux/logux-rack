# frozen_string_literal: true

module Logux
  class Action
    extend Forwardable

    def_delegators(
      :parameters,
      :[],
      :keys,
      :key?,
      :has_key?,
      :values,
      :has_value?,
      :value?,
      :empty?,
      :include?,
      :as_json,
      :to_s,
      :each_key
    )

    def initialize(parameters = {})
      raise ArgumentError, :parameters unless parameters.is_a?(Hash)
      @parameters = parameters.transform_keys(&:to_s)
    end

    def action_name
      type&.split('/')&.dig(0)
    end

    def action_type
      type&.split('/')&.last
    end

    def channel_name
      channel&.split('/')&.dig(0)
    end

    def channel_id
      channel&.split('/')&.last
    end

    def type
      fetch('type')
    end

    def channel
      fetch('channel')
    end

    def fetch(key)
      value = self[key]
      raise ParameterMissingError, key if value.to_s.empty?

      value
    end

    def [](key)
      parameters[key.is_a?(Symbol) ? key.to_s : key]
    end

    private

    attr_reader :parameters
  end
end
