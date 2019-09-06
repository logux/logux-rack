# frozen_string_literal: true

require 'spec_helper'

describe 'Request logux server without subscribe' do
  include_context 'with request'

  let(:logux_params) do
    build(:logux_subscribe_params, password: password, channel: channel)
  end

  context 'when verify_authorized=true' do
    before do
      Logux.configuration.verify_authorized = true
      request_logux
    end

    context 'when policy not exists' do
      let(:channel) { 'notexists/123' }

      it 'returns unknownChannel' do
        expect(JSON.parse(last_response.body)).to include(
          ['unknownChannel', '219_856_768 clientid 0']
        )
      end
    end

    context 'when policy is exists' do
      let(:channel) { 'policy_without_channel/123' }

      it 'returns processed' do
        expect(last_response).to logux_processed('219_856_768 clientid 0')
      end
    end
  end

  context 'when verify_authorized=false' do
    let(:channel) { 'notexists/123' }

    before do
      Logux.configuration.verify_authorized = false
      request_logux
    end

    it 'returns processed' do
      expect(last_response).to logux_processed('219_856_768 clientid 0')
    end
  end
end
