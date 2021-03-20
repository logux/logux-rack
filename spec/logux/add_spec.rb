# frozen_string_literal: true

require 'spec_helper'

describe Logux::Add, timecop: true do
  let(:request) { described_class.new }

  describe '#call' do
    let(:action) { { id: 1 } }
    let(:meta) { create(:logux_meta) }

    it 'return processed' do
      expect { request.call([[action, meta]]) }.to send_to_logux(
        command: 'action', action: { id: 1 }, meta: a_logux_meta
      )
    end
  end
end
