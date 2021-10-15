# frozen_string_literal: true

module Logux
  module Rack
    class Service
      ERROR = {
        attempts: 'Too many wrong secret attempts',
        secret: 'Wrong secret',
        protocol: 'Back-end protocol version is not supported',
        body: 'Wrong body'
      }.freeze

      def initialize(request)
        @request = request
      end

      def process
        catch(:halt) do
          validate_request!
          body = lambda do |io|
            build_response(io)
          ensure
            io.close
          end
          [200, { 'rack.hijack' => body }, []]
        rescue JSON::ParserError
          halt(400, ERROR[:body])
        end
      end

      private

      def halt(code, error)
        response = [code, { 'Content-Type' => 'application/json' }, [error]]
        throw :halt, response
      end

      def validate_request!
        halt(429, ERROR[:attempts]) unless Logux.throttle.allow_request(request_ip)
        halt(400, ERROR[:body]) unless Logux.valid_body?(logux_params)
        check_secret
        halt(400, ERROR[:protocol]) unless Logux.valid_protocol?(meta_params)
        true
      end

      def check_secret
        if Logux.valid_secret?(meta_params)
          Logux.throttle.clear(request_ip)
        else
          Logux.throttle.remember_bad_auth(request_ip, Time.now.to_i)
          halt(403, ERROR[:secret])
        end
      end

      def build_response(out)
        logux_stream = Logux::Stream.new(out)
        logux_stream.write('[')
        Logux.process_batch(stream: logux_stream, batch: command_params)
        logux_stream.write(']')
      end

      def logux_params
        @logux_params ||= JSON.parse(@request.body.read)
      end

      def command_params
        logux_params['commands'] || []
      end

      def request_ip
        @request_ip ||= @request.ip
      end

      def meta_params
        logux_params&.slice('version', 'secret', 'id')
      end
    end

    class App
      class HijackNotAvailable < RuntimeError; end

      def self.call(env)
        raise HijackNotAvailable unless env['rack.hijack']

        Service.new(::Rack::Request.new(env)).process
      end
    end
  end

  def self.application
    Logux::Rack::App
  end
end
