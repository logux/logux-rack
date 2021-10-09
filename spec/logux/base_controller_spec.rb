# frozen_string_literal: true

require 'spec_helper'

describe Logux::BaseController do
  let(:controller) { described_class.new(action: action, meta: meta) }
  let(:action) { create(:logux_action_subscribe) }
  let(:meta) { Logux::Meta.new }

  describe 'accessors' do
    it { expect(controller.node_id).to eq(meta.node_id) }
  end
end
