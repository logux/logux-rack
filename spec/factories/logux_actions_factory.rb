# frozen_string_literal: true

FactoryBot.define do
  factory :logux_action, class: Logux::Action do
    factory :logux_action_subscribe do
      skip_create
      initialize_with do
        new({ type: 'logux/subscribe', channel: 'user/1' }.merge(attributes))
      end
    end

    factory :logux_action_subscribe_since do
      skip_create
      initialize_with do
        new({
          type: 'logux/subscribe',
          channel: 'user/1',
          since: { 'time' => 100_000 }
        }.merge(attributes))
      end
    end

    factory :logux_action_add do
      skip_create
      initialize_with do
        new({ type: 'user/add', key: 'name', value: 'test' }.merge(attributes))
      end
    end

    factory :logux_action_update do
      skip_create
      initialize_with do
        new({ type: 'user/add', key: 'name', value: 'test' }.merge(attributes))
      end
    end

    factory :logux_action_unknown do
      skip_create
      initialize_with do
        new({ type: 'unknown/action' }.merge(attributes))
      end
    end

    factory :logux_action_unknown_subscribe do
      skip_create
      initialize_with do
        new(
          { type: 'logux/subscribe', channel: 'unknown/channel' }
            .merge(attributes)
        )
      end
    end

    factory :logux_action_post do
      skip_create
      initialize_with do
        new(
          { type: 'post/rename', key: 'name', value: 'test' }.merge(attributes)
        )
      end
    end
  end
end
