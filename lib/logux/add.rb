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
      client.post(prepared_data)
    end

    private

    def prepare_data(commands)
      {
        version: PROTOCOL_VERSION,
        secret: secret,
        commands: commands.map { |command| build_command(command) }
      }
    end

    def build_command(command)
      {
        command: 'action',
        action: command.first,
        meta: command[1] || Meta.new
      }
    end
  end
end
