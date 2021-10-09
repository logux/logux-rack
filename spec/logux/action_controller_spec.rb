# frozen_string_literal: true

require 'spec_helper'

describe Logux::ActionController do
  let(:action_controller) { described_class.new(action: action, meta: meta) }
  let(:action) { create(:logux_action_subscribe) }
  let(:meta) { Logux::Meta.new }

  describe '#respond' do
    subject(:response) { action_controller.respond(:processed) }

    let(:expected) do
      {
        status: :processed,
        action: action,
        custom_data: nil
      }
    end

    it { expect(response).to have_attributes(**expected) }
    it { expect(response.meta).to have_key('time') }
  end

  describe '#send_back' do
    subject(:send_back) { action_controller.send_back(back_action, back_meta) }

    let(:back_action) { { 'type' => 'added' } }
    let(:back_meta) { { 'meta_key' => 'meta_value' } }

    let(:expected_commands) do
      {
        'command' => 'action',
        'action' => back_action,
        'meta' => a_logux_meta_with(
          { clients: [meta.client_id] }.merge(back_meta)
        )
      }
    end

    it 'makes request with correct clients' do
      expect { send_back }.to send_to_logux(expected_commands)
    end
  end

  describe '.resend' do
    subject(:resend) do
      described_class.receivers_by_action(action.type, action)
    end

    let(:action_type) { action.type }
    let(:receivers) { { 'channel' => 'users' } }

    before do
      local_action_type = action_type.split('/').last
      local_receivers = receivers

      described_class.class_eval do
        resend local_action_type, local_receivers
        resend 'not_existing_action', 'another' => 'receivers'
      end
    end

    after do
      described_class.class_eval do
        @resend_targets = {}
      end
    end

    context 'when receivers is a hash' do
      it 'returns receivers as hash' do
        expect(resend).to eq(receivers)
      end
    end

    context 'when receivers is a lambda using action' do
      let(:receivers) do
        ->(action) { { 'channel' => "post/#{action.channel_id}" } }
      end

      it 'returns receivers as lambda result' do
        expect(resend).to eq('channel' => "post/#{action.channel_id}")
      end
    end

    context 'when no receivers for such action are defined' do
      let(:action_type) { 'not_existing_too' }

      it 'returns nothing' do
        expect(resend).to be_nil
      end
    end
  end

  describe '.verify_authorized!' do
    subject(:verify_authorized!) { described_class.verify_authorized! }

    around do |example|
      Logux.configuration.verify_authorized = false
      example.call
      Logux.configuration.verify_authorized = true
    end

    it 'sets to true' do
      expect { verify_authorized! }
        .to change { Logux.configuration.verify_authorized }
        .from(false)
        .to(true)
    end
  end

  describe '.unverify_authorized!' do
    subject(:unverify_authorized!) { described_class.unverify_authorized! }

    before { Logux.configuration.verify_authorized = true }

    it 'sets to false' do
      expect { unverify_authorized! }
        .to change { Logux.configuration.verify_authorized }
        .from(true)
        .to(false)
    end
  end
end
