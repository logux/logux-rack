# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'
require_relative 'rack'

module Logux
  class RakeTasks < ::Rake::TaskLib
    attr_accessor :name, :verbose, :fail_on_error, :patterns, :formatters, :requires, :options

    using Logux::Utils

    ACTIONS_NAMESPACE = 'Actions'
    CHANNELS_NAMESPACE = 'Channels'

    # rubocop:disable Metrics/AbcSize
    def initialize(name = :logux)
      setup(name)
      namespace(name) do
        desc 'Lists all Logux action types'
        task(:actions, [:actions_path]) do |_, task_args|
          task_args.with_defaults(actions_path: default_actions_path)
          require_all(task_args.actions_path)
          report(ACTIONS_HEAD, action_types)
        end

        desc 'Lists all Logux channel'
        task(:channels, [:channels_path]) do |_, task_args|
          task_args.with_defaults(channels_path: default_channels_path)
          require_all(task_args.channels_path)
          report(CHANNELS_HEAD, channels)
        end
      end
    end
    # rubocop:enable Metrics/AbcSize

    protected

    def default_actions_path
      File.join(Dir.pwd, '**', 'actions')
    end

    def default_channels_path
      File.join(Dir.pwd, '**', 'channels')
    end

    private

    def setup(name)
      @name = name
      @verbose = true
      @fail_on_error = true
      @patterns = []
      @requires = []
      @options = []
      @formatters = []
    end

    ACTIONS_HEAD = [%w[action.type Class#method]].freeze
    CHANNELS_HEAD = [%w[channel Class]].freeze
    private_constant :ACTIONS_HEAD, :CHANNELS_HEAD

    def require_all(path)
      Dir[File.join(path, '**', '*.rb')].each do |file|
        require file
      end
    end

    def action_types
      classes = descendants_of(::Logux::ActionController).sort_by(&:name)
      classes.flat_map { |klass| action_methods(klass) }
    end

    def action_methods(klass)
      prefix = action_type(klass)
      klass.instance_methods(false).sort.map do |action|
        [[prefix, action].join('/'), [klass.name, action].join('#')]
      end
    end

    def action_type(klass)
      strip_namespace(klass, ACTIONS_NAMESPACE)
    end

    def channels
      classes = descendants_of(::Logux::ChannelController)
      classes.select(&:name).sort_by(&:name).map do |klass|
        [channel(klass), klass]
      end
    end

    def channel(klass)
      strip_namespace(klass, CHANNELS_NAMESPACE)
    end

    def strip_namespace(klass, namespace)
      klass.name.gsub(/^#{namespace}::/, '').underscore
    end

    def descendants_of(parent)
      ObjectSpace.each_object(Class).select { |klass| klass < parent }
    end

    def report(header, items)
      output = header + items
      first_column_length = output.map(&:first).max_by(&:length).length
      output.each do |entity, klass_name|
        puts "#{entity.rjust(first_column_length, ' ')} #{klass_name}"
      end
    end
  end
end
