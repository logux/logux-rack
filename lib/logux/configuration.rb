# frozen_string_literal: true

module Logux
  class Configuration
    attr_accessor(
      :secret,
      :logux_host,
      :verify_authorized,
      :logger,
      :on_error,
      :auth_rule,
      :render_backtrace_on_error,
      :action_watcher,
      :action_watcher_options,
      :subprotocol,
      :supports,
      :throttle_settings,
      :throttle_cache
    )

    def initialize
      @secret = nil
      @logux_host = 'localhost:1338'
      @verify_authorized = true
      @logger = ::Logger.new($stdout)
      @on_error = proc {}
      @auth_rule = proc { false }
      @render_backtrace_on_error = true
      @action_watcher = Logux::ActionWatcher
      @action_watcher_options = {}
      @subprotocol = '1.0.0'
      @supports = '^1.0.0'
      @throttle_settings = { num_requests: 3, duration: 5 }
      @throttle_cache = {}
    end
  end
end
