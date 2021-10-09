# frozen_string_literal: true

describe Logux, timecop: true do
  it 'has a version number' do
    expect(Logux::Rack::VERSION).not_to be nil
  end

  describe '.add' do
    let(:action) { { type: 'action' } }

    describe 'http request' do
      it 'makes request' do
        stub = stub_request(:post, described_class.configuration.logux_host)
        Logux::Test.enable_http_requests! { described_class.add(action) }
        expect(stub).to have_been_requested
      end
    end

    it 'sends action with meta' do
      expect { described_class.add(action) }.to send_to_logux(
        command: 'action', action: a_logux_action_with(type: 'action'),
        meta: a_logux_meta
      )
    end
  end

  describe '.add_batch' do
    let(:commands) do
      [
        [{ type: 'action' }],
        [{ type: 'action2' }]
      ]
    end

    let(:action_first) do
      {
        command: 'action',
        action: a_logux_action_with(type: 'action'),
        meta: a_logux_meta
      }
    end

    let(:action_second) do
      {
        command: 'action',
        action: a_logux_action_with(type: 'action2'),
        meta: a_logux_meta
      }
    end

    describe 'http request' do
      it 'makes a request' do
        stub = stub_request(:post, described_class.configuration.logux_host)
        Logux::Test.enable_http_requests! { described_class.add(commands) }
        expect(stub).to have_been_requested
      end
    end

    it 'sends action with meta' do
      expect { described_class.add_batch(commands) }
        .to send_to_logux(action_first, action_second)
    end
  end

  describe '.generate_action_id' do
    subject(:action_id) { described_class.generate_action_id }

    it 'returns correct action id' do
      expect(action_id).not_to be_empty
    end
  end

  describe '.undo' do
    let(:meta) do
      Logux::Meta.new(
        id: '1 1:client:uuid 0',
        users: ['3'],
        reasons: ['user/1/lastValue'],
        nodes: ['2:uuid'],
        channels: ['user/1']
      )
    end
    let(:reason) { 'error' }

    context 'when extra data is not provided' do
      let(:request) { described_class.undo(meta, reason: reason) }
      let(:logux_commands) do
        {
          command: 'action',
          action: { type: 'logux/undo', id: meta.id, reason: reason },
          meta: a_logux_meta_with(clients: ['1:client'])
        }
      end

      it 'makes request' do
        expect { request }.to send_to_logux(logux_commands)
      end
    end

    context 'when data provided' do
      let(:request) do
        described_class.undo(
          meta,
          reason: reason,
          data: { errors: ['limitExceeded'] }
        )
      end
      let(:logux_commands) do
        {
          command: 'action',
          action: {
            type: 'logux/undo',
            id: meta.id,
            reason: reason,
            errors: ['limitExceeded']
          },
          meta: a_logux_meta_with(clients: ['1:client'])
        }
      end

      it 'makes request' do
        expect { request }.to send_to_logux(logux_commands)
      end
    end

    describe 'logging' do
      let(:logger) { instance_double(Logger, warn: true) }

      before do
        allow(described_class).to receive(:logger).and_return(logger)
      end

      it 'warn if secret is empty' do
        described_class.valid_secret?(secret: nil)
        expect(logger).to have_received(:warn)
      end
    end
  end

  describe '.application' do
    it 'has Railsy shortcut for a Rack application' do
      expect(described_class.application).to respond_to(:call)
    end
  end
end
