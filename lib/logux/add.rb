# frozen_string_literal: true

module Logux
  class Add
    attr_reader :client, :version, :secret

    def initialize(
      client: Logux::Client.new,
      version: Logux::PROTOCOL_VERSION,
      secret: Logux.configuration.secret
    )
      @client = client
      @version = version
      @secret = secret
    end

    def call(commands)
      return if commands.empty?

      prepared_data = prepare_data(commands)
      Logux.logger.debug("Logux add: #{prepared_data}")
      client.post(prepared_data)
    end

    private

    def prepare_data(commands)
      {
        version: PROTOCOL_VERSION,
        secret: secret,
        commands: commands.map do |command|
          action = command.first
          meta = command[1]

          {
            command: 'action',
            action: action,
            meta: meta || Meta.new
          }
        end
      }
    end
  end
end
