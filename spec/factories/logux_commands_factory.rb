# frozen_string_literal: true

FactoryBot.define do
  factory :logux_command, class: 'Array' do
    skip_create

    initialize_with do
      {
        command: 'action',
        action: attributes[:action],
        meta: {
          time: Time.now.to_i,
          id: '219_856_768 clientid 0',
          userId: 1
        }
      }
    end

    factory :subscribe_command do
      initialize_with do
        build(
          :logux_command,
          action: {
            type: 'logux/subscribe',
            channel: attributes[:channel]
          }
        )
      end
    end

    factory :add_command do
      initialize_with do
        build(
          :logux_command,
          action: {
            type: 'comment/add',
            key: 'text',
            value: 'hi'
          }
        )
      end
    end

    factory :update_command do
      initialize_with do
        build(
          :logux_command,
          action: {
            type: 'comment/update',
            key: 'text',
            value: 'hi'
          }
        )
      end
    end

    factory :custom_command do
      initialize_with do
        build(
          :logux_command,
          action: {
            type: attributes[:type],
            key: 'text',
            value: 'hi'
          }
        )
      end
    end
  end
end
