# frozen_string_literal: true

require 'bundler/setup'
require 'logux/rack'

run Logux.application
