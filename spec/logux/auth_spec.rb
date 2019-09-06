# frozen_string_literal: true

require 'spec_helper'

describe Logux::Auth do
  subject(:auth) do
    described_class.new(
      user_id: user_id,
      credentials: credentials,
      auth_id: auth_id
    )
  end

  let(:user_id) { '123' }
  let(:credentials) { 'sample-credentials' }
  let(:auth_id) { 'sample-auth-id' }

  describe '#new' do
    it 'exposes user_id' do
      expect(auth.user_id).to eq(user_id)
    end

    it 'exposes credentials' do
      expect(auth.credentials).to eq(credentials)
    end

    it 'exposes auth_id' do
      expect(auth.auth_id).to eq(auth_id)
    end
  end
end
