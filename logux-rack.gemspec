# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logux/version'

Gem::Specification.new do |spec|
  spec.name          = 'logux-rack'
  spec.version       = Logux::VERSION
  spec.authors       = ['WildDima']
  spec.email         = ['dtopornin@gmail.com']
  spec.summary       = 'Rack application backend for Logux proxy server'

  spec.description   = %(
    This gem provides building blocks to integrate Logux server
    interaction features into a Rack-based web applications.
  ).strip.gsub(/\s+/, ' ')

  spec.homepage      = 'https://github.com/logux'
  spec.license       = 'MIT'

  spec.metadata['source_code_uri'] = 'https://github.com/logux/logux-rack'
  spec.metadata['changelog_uri'] = 'https://github.com/logux/logux-rack/CHANGELOG.md'

  EXCLUDE_PATHS = %w[
    spec
  ].freeze

  EXCLUDE_FILES = %w[
    .gitignore
    .pryrc
    .rspec
    .rubocop.yml
    .travis.yml
    Appraisals
  ].freeze

  EXCLUDE_PATTERN = %r{^(#{EXCLUDE_PATHS.join("|")}/)}.freeze

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(EXCLUDE_PATTERN) } - EXCLUDE_FILES
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'colorize'
  spec.add_dependency 'configurations'
  spec.add_dependency 'nanoid'
  spec.add_dependency 'rack', '~> 2.0'
  spec.add_dependency 'rest-client'
  spec.add_dependency 'sinatra', '>= 2.0', '< 3'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.60.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.27.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'webmock'
end
