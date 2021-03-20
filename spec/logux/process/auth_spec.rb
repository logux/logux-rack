# frozen_string_literal: true

require 'spec_helper'

describe Logux::Process::Auth do
  subject(:auth_process) { described_class.new(stream: stream, chunk: chunk) }

  before do
    Logux.configure { |config| config.auth_rule = -> { true } }
  end

  let(:stream) { Object.new }

  let(:chunk) do
    Logux::Auth.new(
      user_id: 'sample_user-id',
      auth_id: 'sample-auth-id',
      token: 'sample-token',
      cookie: 'sample-cookie',
      subprotocol: '1.0.0',
      headers: 'sample-headers'
    )
  end

  describe '#new' do
    it 'exposes stream' do
      expect(auth_process.stream).to eq(stream)
    end

    it 'exposes chunk' do
      expect(auth_process.chunk).to eq(chunk)
    end
  end
end
