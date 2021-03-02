# frozen_string_literal: true

require 'spec_helper'

describe Logux::Client do
  let(:client) { described_class.new }
  let(:meta) { create(:logux_meta) }
  let(:commands) do
    [{ command: 'action', action: { id: 1 }, meta: meta },
     { command: 'action', action: { id: 2 }, meta: meta }]
  end
  let(:params) do
    {
      version: Logux::PROTOCOL_VERSION,
      secret: nil,
      commands: commands
    }
  end

  let(:first_action) do
    { command: 'action', action: { id: 1 }, meta: a_logux_meta }
  end

  let(:second_action) do
    { command: 'action', action: { id: 2 }, meta: a_logux_meta }
  end

  describe '#post' do
    it 'performs request' do
      expect { client.post(params) }
        .to send_to_logux(first_action, second_action)
    end
  end
end
