# frozen_string_literal: true

module Logux
  class Throttle
    include ::Singleton

    attr_reader :cache, :duration, :num_requests, :nano

    def self.instance
      @@instance ||= new
    end

    def initialize
      @cache = Logux.configuration.throttle_cache
      @num_requests = Logux.configuration.throttle_settings[:num_requests]
      @duration = Logux.configuration.throttle_settings[:duration]
    end

    def allow_request(key)
      return true unless key && read_cache(key)

      now = Time.now.to_i - @duration
      history = read_cache(key)
      new_history = history
      history.reverse_each do |h|
        new_history = new_history[0...-1] if h <= now
      end
      new_history.length <= @num_requests
    end

    def clear(key)
      delete_cache(key) if read_cache(key)
    end

    def remember_bad_auth(key, time)
      if read_cache(key)
        write_cache(key, read_cache(key) + [time])
      else
        write_cache(key, [time])
      end
    end

    private

    def cache_type
      @cache.class.to_s
    end

    def read_cache(key)
      if cache_type == 'ActiveSupport::Cache::MemoryStore'
        @cache.read(key)
      else
        @cache[key]
      end
    end

    def write_cache(key, value)
      if cache_type == 'ActiveSupport::Cache::MemoryStore'
        @cache.write(key, value)
      else
        @cache[key] = value
      end
    end

    def delete_cache(key)
      if cache_type == 'ActiveSupport::Cache::MemoryStore'
        @cache.delete(key)
      else
        @cache.delete(key)
      end
    end
  end
end
