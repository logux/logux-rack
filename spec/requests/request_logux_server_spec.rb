# frozen_string_literal: true

require 'spec_helper'

describe 'Request logux server' do
  subject { request_logux }

  include_context 'with request'

  context 'when secret is wrong' do
    let(:logux_params) { build(:logux_params, secret: 'wrong') }

    it { is_expected.to be_forbidden }

    it { is_expected.to eq_body(Logux::Rack::App::ERROR[:secret]) }
  end

  context 'when body is not a json' do
    subject { post '/logux', '' }

    it { is_expected.to be_bad_request }

    it { is_expected.to eq_body(Logux::Rack::App::ERROR[:body]) }
  end

  context 'when protocol is not supported' do
    let(:logux_params) { build(:logux_params, protocol_version: -1) }

    it { is_expected.to be_bad_request }

    it { is_expected.to eq_body(Logux::Rack::App::ERROR[:protocol]) }
  end

  context 'when authorization required' do
    context 'when authorized' do
      let(:logux_params) { build(:logux_batch_params) }

      it { is_expected.to logux_approved('219_856_768 clientid 0') }

      it { is_expected.to logux_resent('219_856_768 clientid 0') }
    end
  end

  context 'with proxy' do
    let(:logux_params) { build(:logux_batch_params) }

    it 'updates store' do
      expect { request_logux }.to change { logux_store.size }.by(1)
    end
  end
end
