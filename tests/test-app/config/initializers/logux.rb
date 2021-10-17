# frozen_string_literal: true

Logux.configure do |config|
  config.secret = 'parole'
  config.logux_host = 'http://localhost:31337/'
  config.logger = ::Logger.new($stdout)
  config.subprotocol = '1.0.0'
  config.supports = '^1.0.0'

  config.auth_rule = lambda do |user_id, token, cookie, headers|
    raise headers['error'] if headers['error'].present?
    return true if token == "#{user_id}:good"
    return true if cookie['token'] == "#{user_id}:good"
    false
  end
end
