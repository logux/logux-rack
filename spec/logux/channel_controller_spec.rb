# frozen_string_literal: true

require 'spec_helper'

describe Logux::ChannelController do
  let(:controller_class) do
    Class.new(described_class) do
      def initial_data
        [{ type: 'action' }]
      end
    end
  end
  let(:channel_controller) { controller_class.new(action: action, meta: meta) }
  let(:user) { User.find_or_create_by(id: 1, name: 'test') }
  let(:meta) { Logux::Meta.new }

  describe '#subscribe' do
    subject(:subscribe) { channel_controller.subscribe }

    let(:action) { create(:logux_action_subscribe) }

    context 'when ActiveRecord defined' do
      it 'tries to find record by chanel data' do
        expect { subscribe }
          .to send_to_logux(command: 'action', action: { type: 'action' })
      end
    end
  end

  describe '#since_time' do
    subject(:since_time) { channel_controller.since_time }

    context 'when action.since defined' do
      let(:action) { create(:logux_action_subscribe_since) }

      it 'tries to find record by chanel data' do
        expect(since_time).to eql(Time.at(100).to_datetime)
      end
    end

    context 'when action.since not defined' do
      let(:action) { create(:logux_action_subscribe) }

      it 'tries to find record by chanel data' do
        expect(since_time).to be_nil
      end
    end
  end

  describe '#initial_data' do
    let(:action) { create(:logux_action_subscribe) }
    let(:empty_controller_class) { Class.new(described_class) }
    let(:empty_controller) { empty_controller_class.new(action: action) }

    it { expect(empty_controller.initial_data).to be_empty }
  end
end
