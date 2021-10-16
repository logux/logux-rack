# frozen_String_literal: true

require 'spec_helper'

shared_context 'with request' do
  subject(:request_logux) { post('/logux', logux_params.to_json, { 'rack.hijack' => true }) }

  before do
    Logux.configure { |config| config.secret = 'secret' }
  end

  let(:app) { Logux::Rack::App }
  let(:secret) { Logux.configuration.secret }
end
