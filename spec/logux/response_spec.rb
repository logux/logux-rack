# frozen_string_literal: true

require 'spec_helper'

describe Logux::Response do
  subject(:response) do
    described_class.new(
      status,
      action: action,
      meta: meta,
      custom_data: custom_data
    )
  end

  let(:status) { :processed }
  let(:action) { { type: 'action' } }
  let(:id) { '1 user:client:id 0' }
  let(:meta) { Logux::Meta.new(id: id) }
  let(:custom_data) { { custom: 'data' } }

  describe '#new' do
    it 'exposes status' do
      expect(response.status).to eq(status)
    end

    it 'exposes action' do
      expect(response.action).to eq(action)
    end

    it 'exposes meta' do
      expect(response.meta).to eq(meta)
    end
  end

  describe '#format' do
    subject(:response_with_no_custom_data) do
      described_class.new(
        status,
        action: action,
        meta: meta
      )
    end

    it 'contain custom data' do
      expect(response.format).to eq({ answer: status, id: meta.id, custom_data: custom_data })
    end

    it 'contain meta.id' do
      expect(response_with_no_custom_data.format).to eq({ answer: status, id: meta.id, custom_data: nil })
    end
  end
end
