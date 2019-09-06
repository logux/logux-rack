# frozen_string_literal: true

module Logux
  class Stream
    extend Forwardable

    attr_reader :stream

    def_delegators :stream, :close

    def initialize(stream)
      @stream = stream
    end

    def write(payload)
      processed_payload = process(payload)
      Logux.logger.debug("Write to Logux response: #{processed_payload}")
      stream << processed_payload
    end

    private

    def process(payload)
      payload.is_a?(::String) ? payload : payload.to_json
    end
  end
end
