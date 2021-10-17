# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logux/rack/version'

Gem::Specification.new do |spec|
  spec.name          = 'logux-rack'
  spec.version       = Logux::Rack::VERSION
  spec.authors       = ['WildDima', 'Alex Musayev']
  spec.email         = ['dtopornin@gmail.com', 'alex.musayev@gmail.com']
  spec.summary       = 'Rack application backend for Logux proxy server'

  spec.description   = <<~DESCRIPTION.strip.gsub(/\s+/, ' ')
    This gem provides building blocks to integrate Logux server
    interaction features into a Rack-based web applications.
  DESCRIPTION

  spec.homepage      = 'https://logux.io/'
  spec.license       = 'MIT'

  spec.metadata['source_code_uri'] = 'https://github.com/logux/logux-rack'
  spec.metadata['changelog_uri'] = 'https://github.com/logux/logux-rack/CHANGELOG.md'

  spec.files = Dir.glob('{bin,lib}/**/*') + %w[LICENSE.txt README.md CHANGELOG.md]
  spec.require_paths = ['lib']

  spec.add_dependency 'nanoid'
  spec.add_dependency 'rack', '~> 2.0'
  spec.add_dependency 'semantic_range'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 1.22'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.5'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'webmock'
end
