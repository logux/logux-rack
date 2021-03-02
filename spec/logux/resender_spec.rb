# frozen_string_literal: true

require 'spec_helper'

describe Logux::Resender do
  let(:resender) { described_class.new(action: action, meta: meta, headers: headers) }
  let(:action) { create(:logux_action_add) }
  let(:meta) { create(:logux_meta) }
  let(:headers) { {} }

  describe '#call!' do
    subject(:result) { resender.call! }

    context 'without existing action class' do
      it { is_expected.to be_nil }
    end

    context 'when no receivers are defined' do
      before do
        module Actions
          class User < Logux::ActionController
            class << self
              undef_method :receivers_by_action
            end

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

      it { is_expected.to be_nil }
    end

    context 'when no receivers for this actions are defined' do
      before do
        module Actions
          class User < Logux::ActionController
            resend :remove, channel: 'users'

            def add
              respond(:ok)
            end

            def remove
              respond(:ok)
            end
          end
        end
      end

      after do
        Actions::User.send :undef_method, :add
        Actions::User.send :undef_method, :remove
        Actions::User.send :instance_variable_set, '@resend_targets', {}
        Actions.send :remove_const, :User
      end

      it { is_expected.to be_nil }
    end

    context 'with defined receivers' do
      before do
        module Actions
          class User < Logux::ActionController
            resend :add, channel: 'users'

            def add
              respond(:ok)
            end
          end
        end
      end

      after do
        Actions::User.send :undef_method, :add
        Actions::User.send :instance_variable_set, '@resend_targets', {}
        Actions.send :remove_const, :User
      end

      it { is_expected.to eq({ answer: 'resend', channel: 'users', id: meta['id'] }) }
    end
  end
end
