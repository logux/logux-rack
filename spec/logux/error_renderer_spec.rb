# frozen_string_literal: true

require 'spec_helper'

describe Logux::ErrorRenderer do
  let(:action_id) { '123 10:uuid 0' }
  let(:meta) { create(:logux_meta, id: action_id) }

  describe '#message' do
    subject(:response) { described_class.new(exception).message }

    context 'when UnknownActionError' do
      let(:exception) { Logux::UnknownActionError.new(message, meta: meta) }
      let(:message) { 'test' }

      it { is_expected.to eq(answer: 'unknownAction', id: action_id) }
    end

    context 'when UnknownChannelError' do
      let(:exception) { Logux::UnknownChannelError.new('test', meta: meta) }
      let(:message) { 'test' }

      it { is_expected.to eq(answer: 'unknownChannel', id: action_id) }
    end

    context 'when StandardError' do
      let(:exception) { StandardError.new(message) }
      let(:error_message) { "#{message}\n#{exception.backtrace.join("\n")}" }
      let(:message) { 'test' }

      before do
        exception.set_backtrace(caller)
      end

      it { is_expected.to eq(answer: 'error', details: error_message) }
    end

    context 'when render_backtrace_on_error is false' do
      let(:exception) { StandardError.new }

      before do
        Logux.configuration.render_backtrace_on_error = false
      end

      it 'return server logs error' do
        expect(response).to eq(
          answer: 'error',
          details: 'Please check server logs for more information'
        )
      end
    end
  end
end
