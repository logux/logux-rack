# frozen_string_literal: true

namespace :logux do
  desc 'Lists all Logux action types'
  task actions: :environment do
    Dir[Rails.root.join('app', 'logux', 'actions', '**', '*.rb')].each do |file|
      require file
    end

    puts "action.type\tClass#method"
    Logux::ActionController.descendants.sort_by(&:name).each do |controller_klass|
      controller_klass.instance_methods(false).each do |action|
        action_type = "#{controller_klass.name.demodulize.underscore}/#{action}"
        puts "#{action_type}\t#{controller_klass.name}##{action}"
      end
    end
  end

  desc 'Lists all Logux channels'
  task channels: :environment do
    Dir[Rails.root.join('app', 'logux', 'channels', '**', '*.rb')].each do |file|
      require file
    end

    puts "channel\tClass"
    Logux::ChannelController.descendants.map(&:name).sort.each do |klass_name|
      puts "#{klass_name.demodulize.underscore}\t#{klass_name}"
    end
  end
end
