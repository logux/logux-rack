# frozen_string_literal: true

require 'spec_helper'

describe Logux::Process::Batch do
  subject(:batch_process) { described_class.new(stream: stream, batch: batch) }

  let(:stream) { Object.new }
  let(:batch) { Object.new }

  describe '#new' do
    it 'exposes stream' do
      expect(batch_process.stream).to eq(stream)
    end

    it 'exposes batch' do
      expect(batch_process.batch).to eq(batch)
    end
  end
end
