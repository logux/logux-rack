# frozen_string_literal: true

require 'spec_helper'

describe Logux::Node do
  let(:node) { described_class.instance }

  def id_pattern(sequence: /\d+/)
    /^[0-9]{13} server:.{#{Logux::Node::NODE_ID_SIZE}} #{sequence}$/
  end

  describe '#generate_action_id' do
    subject(:action_id) { node.generate_action_id }

    it('returns correct id') { expect(action_id).to match(id_pattern) }

    context 'with action at the same time', timecop: true do
      before do
        node.sequence = 0
        node.last_time = nil
        node.generate_action_id
      end

      it('returns 1 in sequence') do
        expect(action_id).to match(id_pattern(sequence: 1))
      end
    end
  end

  describe '#node_id' do
    subject(:node_id) { node.node_id }

    it { expect(node_id).to be_present }

    it "doesn't change from call to call" do
      expect(node_id).to eq(node.node_id)
    end
  end
end
