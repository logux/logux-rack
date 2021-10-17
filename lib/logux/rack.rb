# frozen_string_literal: true

require 'forwardable'
require 'json'
require 'logger'
require 'nanoid'
require 'net/http'
require 'singleton'

module Logux
  PROTOCOL_VERSION = 4

  class WithMetaError < StandardError
    attr_reader :meta

    def initialize(msg, meta: nil)
      @meta = meta
      super(msg)
    end
  end

  UnknownActionError = Class.new(WithMetaError)
  UnknownChannelError = Class.new(WithMetaError)
  ParameterMissingError = Class.new(StandardError)
  RequestError = Class.new(StandardError)

  autoload :Configuration, 'logux/configuration'
  autoload :Client, 'logux/client'
  autoload :Meta, 'logux/meta'
  autoload :Action, 'logux/action'
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
  autoload :IsFirstOlder, 'logux/is_first_older'
  autoload :Throttle, 'logux/throttle'

  module Rack
    autoload :App, 'logux/rack/app'
  end

  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Logux::Configuration.new
    end

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

    def valid_secret?(meta_params)
      logger.warn('Please, define Logux server secret') unless configuration.secret
      configuration.secret == meta_params&.dig('secret')
    end

    def valid_protocol?(meta_params)
      Logux::PROTOCOL_VERSION == meta_params&.dig('version')
    end

    def valid_body?(params)
      params.is_a?(Hash)
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

    def watch_action(&block)
      action_watcher.call(&block)
    end

    def application
      Logux::Rack::App
    end

    def throttle
      Logux::Throttle.instance
    end
  end
end
