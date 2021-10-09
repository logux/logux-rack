# frozen_string_literal: true

require 'spec_helper'

describe Logux::Policy do
  subject(:policy) do
    described_class.new(
      action: action,
      meta: meta,
      headers: headers
    )
  end

  let(:action) { create(:logux_action_add) }
  let(:meta) { create(:logux_meta) }
  let(:headers) { {} }

  describe '#new' do
    it { expect(policy.action).to eq(action) }
    it { expect(policy.meta).to eq(meta) }
  end
end
