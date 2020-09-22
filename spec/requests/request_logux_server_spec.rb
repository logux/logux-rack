# frozen_string_literal: true

require 'spec_helper'

describe 'Request logux server' do
  include_context 'with request'

  context 'when authorization required' do
    before { request_logux }

    context 'when authorized' do
      let(:logux_params) { build(:logux_batch_params, secret: secret) }

      it 'returns approved chunk' do
        expect(last_response).to logux_approved('219_856_768 clientid 0')
      end

      it 'returns resend' do
        expect(last_response).to logux_resent('219_856_768 clientid 0')
      end
    end

    context 'when not authorized' do
      let(:logux_params) { build(:logux_update_params) }

      it 'returns correct body' do
        expect(last_response).to logux_forbidden
      end
    end

    context 'when secret wrong' do
      let(:logux_params) { build(:logux_batch_params, secret: 'wrong') }

      it 'returns 500' do
        expect(last_response).to be_server_error
      end

      it 'returns message and backtrace' do
        expect(last_response.body).to include('Incorrect secret')
      end
    end
  end

  context 'with proxy' do
    let(:logux_params) { build(:logux_batch_params) }

    it 'returns correct chunk' do
      expect { request_logux }.to change { logux_store.size }.by(1)
    end
  end
end
