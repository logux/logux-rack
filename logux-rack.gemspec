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

  spec.add_dependency 'nanoid', '~> 2.0'
  spec.add_dependency 'rack', '~> 2.0'
  spec.add_dependency 'semantic_range', '~> 3.0'
  spec.add_development_dependency 'bundler', '~> 2.0', '< 3.0'
  spec.add_development_dependency 'factory_bot', '~> 6.2'
  spec.add_development_dependency 'pry', '~> 0.14'
  spec.add_development_dependency 'pry-byebug', '~> 3.8'
  spec.add_development_dependency 'rack-test', '~> 1.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 1.22'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.5'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
  spec.add_development_dependency 'timecop', '~> 0.9.4'
  spec.add_development_dependency 'webmock', '~> 3.14'
end
