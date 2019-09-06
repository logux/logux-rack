# frozen_String_literal: true

require 'spec_helper'

shared_context 'with request' do
  subject(:request_logux) { post('/logux', logux_params.to_json) }

  before do
    Logux.configure { |config| config.password = 'secret' }
  end

  let(:app) { Logux::Rack::App }
  let(:password) { Logux.configuration.password }
end
