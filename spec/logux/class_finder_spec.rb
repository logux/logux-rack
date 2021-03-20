# frozen_string_literal: true

require 'spec_helper'

describe Logux::ClassFinder do
  let(:finder) do
    described_class.new(action: action, meta: meta, headers: headers)
  end
  let(:meta) { create(:logux_meta) }
  let(:headers) { {} }

  describe '#class_name' do
    subject(:class_name) { finder.class_name }

    let(:action) do
      create(:logux_action_add, type: 'test/test/name/try/user/add')
    end

    it 'returns nested classes' do
      expect(class_name).to eq('Test::Test::Name::Try::User')
    end
  end

  describe '#find_policy_class' do
    subject(:policy_class) { finder.find_policy_class }

    context 'with unknown action' do
      let(:action) { create(:logux_action_unknown) }

      it 'raise an error for unknown action error' do
        expect { policy_class }.to raise_error(Logux::UnknownActionError)
      end
    end

    context 'with unknown subscribe' do
      let(:action) { create(:logux_action_unknown_subscribe) }

      it 'raise an error for unknown action error' do
        expect { policy_class }.to raise_error(Logux::UnknownChannelError)
      end
    end
  end

  describe '#find_action_class' do
    subject(:action_class) { finder.find_action_class }

    context 'with unknown action' do
      let(:action) { create(:logux_action_unknown) }

      it 'raise an error for unknown action error' do
        expect { action_class }.to raise_error(Logux::UnknownActionError)
      end
    end

    context 'with unknown subscribe' do
      let(:action) { create(:logux_action_unknown_subscribe) }

      it 'raise an error for unknown action error' do
        expect { action_class }.to raise_error(Logux::UnknownChannelError)
      end
    end
  end
end
