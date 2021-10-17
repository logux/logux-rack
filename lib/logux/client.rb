# frozen_string_literal: true

module Logux
  class Client
    HEADERS = {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }.freeze

    attr_reader :uri

    def initialize(logux_host: Logux.configuration.logux_host)
      @uri = URI(logux_host)
    end

    def post(params)
      Net::HTTP.post(uri, params.to_json, HEADERS)
    end
  end
end
