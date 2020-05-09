# frozen_string_literal: true

require 'spec_helper'

describe 'Request logux server without action' do
  include_context 'with request'
  let(:logux_params) { build(:logux_custom_params, action_type: action) }

  context 'when verify_authorized=true' do
    before do
      Logux.configuration.verify_authorized = true
      request_logux
    end

    context 'when policy not exists' do
      let(:action) { 'notexists/create' }

      it 'returns unknownAction' do
        expect(JSON.parse(last_response.body)).to include(
          ['unknownAction', '219_856_768 clientid 0', /Unable to find/]
        )
      end
    end

    context 'when policy is exists' do
      let(:action) { 'policy_without_action/create' }

      it 'returns processed' do
        expect(last_response).to logux_processed('219_856_768 clientid 0')
      end
    end
  end

  context 'when verify_authorized=false' do
    let(:action) { 'notexists/create' }

    before do
      Logux.configuration.verify_authorized = false
      request_logux
    end

    it 'returns processed' do
      expect(last_response).to logux_processed('219_856_768 clientid 0')
    end
  end
end
