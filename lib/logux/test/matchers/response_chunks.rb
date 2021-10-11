# frozen_string_literal: true

require_relative 'base'
require 'rack/lint'

module Logux
  module Test
    module Matchers
      class ResponseChunks < Base
        attr_reader :includes, :excludes, :meta

        def initialize(meta:, includes:, excludes: [])
          @meta = meta
          @includes = includes
          @excludes = excludes
        end

        def matches?(actual)
          io = ::Logux::Test::StreamIO.new
          actual.headers['rack.hijack'].call(io)
          io.rewind
          @actual = JSON.parse(io.read)
          match_includes? && match_excludes?
        end

        def failure_message
          data = "expected that #{pretty(@actual)} to has " \
            "#{includes.join(', ')} chunks"
          !excludes.empty? && data += " and doesn't" \
            " has #{excludes.join(', ')} chunks"
          data
        end

        private

        def match_includes?
          @actual.any? do |command|
            includes.include?(command['answer']) &&
              (meta.nil? || (!meta.empty? && command['id'] == meta))
          end
        end

        def match_excludes?
          @actual.empty? || @actual.none? do |command|
            excludes.include?(command['answer'])
          end
        end
      end
    end
  end
end
