# frozen_string_literal: true

require 'spec_helper'

describe Logux::ActionCaller do
  let(:action_caller) { described_class.new(action: action, meta: meta, headers: headers) }
  let(:action) { create(:logux_action_add) }
  let(:meta) { create(:logux_meta) }
  let(:headers) { {} }

  describe '#call!' do
    context 'when action defined' do
      subject(:result) { action_caller.call! }

      before do
        module Actions
          class User < Logux::ActionController
            def add
              respond(:ok)
            end
          end
        end
      end

      after do
        Actions::User.send :undef_method, :add
        Actions.send :remove_const, :User
      end

      it 'return ok' do
        expect(result.status).to eq(:ok)
      end
    end
  end
end
