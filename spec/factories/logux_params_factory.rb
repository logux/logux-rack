# frozen_string_literal: true

FactoryBot.define do
  factory :logux_params, class: Hash do
    skip_create

    initialize_with do
      {
        version: attributes[:protocol_version] || Logux::PROTOCOL_VERSION,
        secret: attributes[:secret] || 'secret',
        commands: attributes[:commands]
      }
    end

    factory :logux_subscribe_params do
      initialize_with do
        build(
          :logux_params,
          commands: [
            build(:subscribe_command, channel: attributes[:channel])
          ]
        )
      end
    end

    factory :logux_custom_params do
      initialize_with do
        build(
          :logux_params,
          commands: [
            build(:custom_command, type: attributes[:action_type])
          ]
        )
      end
    end

    factory :logux_update_params do
      initialize_with do
        build(
          :logux_params,
          commands: [
            build(:update_command)
          ]
        )
      end
    end

    factory :logux_batch_params do
      initialize_with do
        build(
          :logux_params,
          secret: attributes[:secret],
          commands: [
            build(:subscribe_command, channel: 'post/123'),
            build(:add_command)
          ]
        )
      end
    end
  end
end
