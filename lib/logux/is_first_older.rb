# frozen_string_literal: true

# Implementation from the Node API
# https://github.com/logux/core/blob/main/is-first-older/index.js

module Logux
  class IsFirstOlder
    attr_reader :first_meta, :second_meta

    def initialize(first_meta, second_meta)
      @first_meta = first_meta
      @second_meta = second_meta
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Style/GuardClause
    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def call
      if first_meta && !second_meta
        return false
      elsif !first_meta && second_meta
        return true
      end

      if first_meta['time'] > second_meta['time']
        return false
      elsif first_meta['time'] < second_meta['time']
        return true
      end

      first = first_meta['id'].split
      second = second_meta['id'].split

      first_node = first[1]
      second_node = second[1]

      if first_node > second_node
        return false
      elsif first_node < second_node
        return true
      end

      first_counter = Integer(first[2])
      second_counter = Integer(second[2])

      if first_counter > second_counter
        return false
      elsif first_counter < second_counter
        return true
      end

      first_node_time = Integer(first[0])
      second_node_time = Integer(second[0])

      if first_node_time > second_node_time
        return false
      elsif first_node_time < second_node_time
        return true
      end

      false
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Style/GuardClause
  end
end
