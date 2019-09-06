# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require_relative 'lib/logux/rake_tasks'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new
Logux::RakeTasks.new

task default: %i[rubocop spec]
