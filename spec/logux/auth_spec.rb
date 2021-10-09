# frozen_string_literal: true

require 'spec_helper'

describe Logux::Auth do
  subject(:auth) do
    described_class.new(
      user_id: user_id,
      token: token,
      cookie: cookie,
      subprotocol: subprotocol,
      headers: headers,
      auth_id: auth_id
    )
  end

  let(:user_id) { '123' }
  let(:token) { 'token' }
  let(:cookie) { 'cookie' }
  let(:subprotocol) { '1.0.0' }
  let(:headers) { 'headers' }
  let(:auth_id) { 'sample-auth-id' }

  describe '#new' do
    it { expect(auth.user_id).to eq(user_id) }
    it { expect(auth.token).to eq(token) }
    it { expect(auth.cookie).to eq(cookie) }
    it { expect(auth.headers).to eq(headers) }
    it { expect(auth.subprotocol).to eq(subprotocol) }
    it { expect(auth.auth_id).to eq(auth_id) }
  end
end
