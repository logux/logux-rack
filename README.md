<a href="https://amplifr.com/?utm_source=logux-rack">
  <img width="100" height="140" align="right"
    alt="Sponsored by Amplifr" src="https://amplifr-direct.s3-eu-west-1.amazonaws.com/social_images/image/37b580d9-3668-4005-8d5a-137de3a3e77c.png" />
</a>

# Logux::Rack

[![Build Status](https://travis-ci.org/logux/logux-rack.svg?branch=master)](https://travis-ci.org/logux/logux-rack) [![Coverage Status](https://coveralls.io/repos/github/logux/logux-rack/badge.svg?branch=master)](https://coveralls.io/github/logux/logux-rack?branch=master)

Add WebSockets, live-updates and offline-first to any Rack-based application with [Logux](https://github.com/logux/logux/). It adds [Logux Back-end Protocol](https://github.com/logux/logux/blob/master/backend-protocol/spec.md) support to Ruby on Rails or any other Rack applications, so you can use Logux Server as a proxy between WebSocket and your web application.

Read [Creating Logux Proxy](https://github.com/logux/logux/blob/master/2-starting/2-creating-proxy.md) guide.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logux-rack'
```

And then execute:

```bash
bundle
```

## Usage

Here is a minimal Rack configuration to start new `Logux::Rack` server:

```ruby
# config.ru
require 'logux/rack'

run Logux.application
```

Note that the HTTP response streaming depends on the web server used to serve the application. Use a server with streaming capability. [Puma](https://puma.io/), for instance:

```bash
gem install puma
```

Start the server:

```bash
puma config.ru
```

It is possible to mount `Logux::Rack` server within an existing Rails application. First of all, you will need to configure Logux by defining a server address in an initializer. For example, `config/initializers/logux.rb`:

```ruby
Logux.configuration do |config|
  config.logux_host = 'http://localhost:31338'
end
```

Mount `Logux::Rack` in routes:

```ruby
Rails.application.routes.draw do
  mount Logux::Rack::App => '/'
end
```

After this, POST requests to `/logux` will be processed by `LoguxController`. You can redefine it or inherit from, if it necessary, for example, for implementing custom authorization flow.

Here is another routing example for [Roda](https://github.com/jeremyevans/roda) application routing:

```ruby
class MyApp < Roda
  route do |r|
    r.is 'logux' { r.run Logux::Rack::App }
  end
end
```

[Hanami](https://hanamirb.org/) configuration example:

```ruby
# config/environment.rb
Hanami.configure do
  mount Logux::Rack::App, at: '/'
end
```

`Logux::Rack` can also be embedded into another Rack application using [Rack::Builder](https://www.rubydoc.info/gems/rack/Rack/Builder):

```ruby
# config.ru

require 'logux/rack'

app = Rack::Builder.new do
  use Rack::CommonLogger
  map '/logux' { run Logux::Rack::App }
  # ...
end

run app
```

`Logux::Rack` will try to find Action for the specific message from Logux Server. For example, for `project/rename` action, you should define `Action::Project` class, inherited from `Logux::Action` base class, and implement `rename` method.

You can execute `rake logux:actions` to get the list of available action types, or `rake logux:channels` to get the list of available channels. Use optional path parameter to limit the search scope: `rake logux:actions[lib/logux/actions]`

## Development with Docker

After checking out the repo, run:

```bash
docker-compose run app bundle install
```

Run tests with:

```bash
docker-compose run app bundle exec rspec
```

Run RuboCop with:

```bash
docker-compose run app bundle exec rubocop
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
