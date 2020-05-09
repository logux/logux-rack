# frozen_string_literal: true

require 'spec_helper'

describe Logux::ErrorRenderer do
  let(:action_id) { '123 10:uuid 0' }
  let(:meta) { create(:logux_meta, id: action_id) }
  let(:message) { 'test' }

  describe '#message' do
    subject(:built_message) { described_class.new(exception).message }

    context 'with UnknownActionError' do
      let(:exception) { Logux::UnknownActionError.new(message, meta: meta) }

      it { is_expected.to eq(['unknownAction', action_id, message]) }
    end

    context 'with UnknownChannelError' do
      let(:exception) { Logux::UnknownChannelError.new(message, meta: meta) }

      it { is_expected.to eq(['unknownChannel', action_id, message]) }
    end

    context 'with UnauthorizedError' do
      let(:exception) { Logux::UnauthorizedError.new(message) }

      it { is_expected.to eq(['unauthorized', message]) }
    end

    context 'when Logux.configuration.render_backtrace_on_error is true' do
      around do |example|
        Logux.configuration.render_backtrace_on_error = true
        exception.set_backtrace(caller)
        example.run
        Logux.configuration.render_backtrace_on_error = false
      end

      let(:exception) { StandardError.new(message) }
      let(:expected_message) do
        ['error', "#{message}\n" + exception.backtrace.join("\n")]
      end

      it { is_expected.to eq(expected_message) }
    end

    context 'when Logux.configuration.render_backtrace_on_error is false' do
      let(:exception) { StandardError.new(message) }
      let(:expected_message) do
        ['error', 'Please check server logs for more information']
      end

      it { is_expected.to eq(expected_message) }
    end
  end
end
