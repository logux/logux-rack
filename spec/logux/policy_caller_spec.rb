# frozen_string_literal: true

require 'spec_helper'

describe Logux::PolicyCaller do
  subject(:call!) { policy_caller.call! }

  let(:policy_caller) do
    described_class.new(action: action, meta: meta, headers: headers)
  end
  let(:meta) { {} }
  let(:headers) { {} }

  context 'when request is not verified' do
    let(:action) { create(:logux_action_unknown) }

    before do
      Logux.configuration.verify_authorized = false
      allow(Logux.logger).to receive(:warn)
      call!
      Logux.configuration.verify_authorized = true
    end

    it 'doesn\'t raise an error' do
      expect(Logux.logger).to have_received(:warn).once
    end
  end

  context 'when verify_authorized' do
    around do |example|
      Logux.configuration.verify_authorized = true
      example.call
      Logux.configuration.verify_authorized = false
    end

    context 'with unknown action' do
      let(:action) { create(:logux_action_unknown) }

      it 'raises an unknownActionError' do
        expect { call! }.to raise_error(Logux::UnknownActionError)
      end
    end

    context 'with unknown subscribe' do
      let(:action) { create(:logux_action_unknown_subscribe) }

      it 'raises an unknownActionError' do
        expect { call! }.to raise_error(Logux::UnknownChannelError)
      end
    end
  end
end
