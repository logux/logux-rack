# frozen_string_literal: true

module Logux
  class ChannelController < BaseController
    def subscribe
      Logux.add_batch(initial_data.map { |d| [d, initial_meta] })
    end

    def initial_data
      []
    end

    def initial_meta
      { clients: [meta.client_id] }
    end

    def since_time
      @since_time ||= begin
        since = action[:since]&.send(:[], 'time')
        Time.at(since / 1000).to_datetime if since
      end
    end
  end
end
