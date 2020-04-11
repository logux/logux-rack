# frozen_string_literal: true

require 'colorize'
require 'configurations'
require 'forwardable'
require 'json'
require 'logger'
require 'nanoid'
require 'rest-client'
require 'sinatra/base'
require 'singleton'

module Logux
  include Configurations

  PROTOCOL_VERSION = 1

  class WithMetaError < StandardError
    attr_reader :meta

    def initialize(msg, meta: nil)
      @meta = meta
      super(msg)
    end
  end

  UnknownActionError = Class.new(WithMetaError)
  UnknownChannelError = Class.new(WithMetaError)
  UnauthorizedError = Class.new(StandardError)
  ParameterMissingError = Class.new(StandardError)

  autoload :Client, 'logux/client'
  autoload :Meta, 'logux/meta'
  autoload :Action, 'logux/action'
  autoload :Actions, 'logux/actions'
  autoload :Auth, 'logux/auth'
  autoload :BaseController, 'logux/base_controller'
  autoload :ActionController, 'logux/action_controller'
  autoload :ChannelController, 'logux/channel_controller'
  autoload :ClassFinder, 'logux/class_finder'
  autoload :ActionCaller, 'logux/action_caller'
  autoload :PolicyCaller, 'logux/policy_caller'
  autoload :Policy, 'logux/policy'
  autoload :Add, 'logux/add'
  autoload :Node, 'logux/node'
  autoload :Response, 'logux/response'
  autoload :Stream, 'logux/stream'
  autoload :Process, 'logux/process'
  autoload :Resender, 'logux/resender'
  autoload :Version, 'logux/version'
  autoload :Test, 'logux/test'
  autoload :ErrorRenderer, 'logux/error_renderer'
  autoload :Utils, 'logux/utils'
  autoload :ActionWatcher, 'logux/action_watcher'

  configurable %i[
    action_watcher
    action_watcher_options
    auth_rule
    logger
    logux_host
    on_error
    password
    render_backtrace_on_error
    verify_authorized
  ]

  configuration_defaults do |config|
    config.logux_host = 'localhost:1338'
    config.verify_authorized = true
    config.logger = ::Logger.new(STDOUT)
    config.on_error = proc {}
    config.auth_rule = proc { false }
    config.render_backtrace_on_error = true
    config.action_watcher = Logux::ActionWatcher
    config.action_watcher_options = {}
  end

  module Rack
    autoload :App, 'logux/rack/app'
  end

  class << self
    def add(action, meta = Meta.new)
      Logux::Add.new.call([[action, meta]])
    end

    def add_batch(commands)
      Logux::Add.new.call(commands)
    end

    def undo(meta, reason: nil, data: {})
      undo_action = data.merge(type: 'logux/undo', id: meta.id)
      undo_action[:reason] = reason if reason
      add(undo_action, meta.undo_meta)
    end

    def verify_request_meta_data(meta_params)
      if configuration.password.nil?
        logger.warn(%(Please, add password for logux server:
                            Logux.configure do |c|
                              c.password = 'your-password'
                            end))
      end
      auth = configuration.password == meta_params&.dig('password')
      raise UnauthorizedError, 'Incorrect password' unless auth
    end

    def process_batch(stream:, batch:)
      Logux::Process::Batch.new(stream: stream, batch: batch).call
    end

    def generate_action_id
      Logux::Node.instance.generate_action_id
    end

    def logger
      configuration.logger
    end

    def action_watcher
      configuration.action_watcher.new(configuration.action_watcher_options)
    end

    def watch_action
      action_watcher.call { yield }
    end

    def application
      Logux::Rack::App
    end
  end
end
