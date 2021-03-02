# frozen_string_literal: true

module Logux
  module Process
    class Action
      attr_reader :stream, :chunk
      attr_accessor :stop_process

      def initialize(stream:, chunk:)
        @stream = stream
        @chunk = chunk
      end

      def call
        process_resend!
        process_authorization!
        process_action!
      end

      def action_from_chunk
        @action_from_chunk ||= chunk[:action]
      end

      def meta_from_chunk
        @meta_from_chunk ||= chunk[:meta]
      end

      def headers_from_chunk
        @headers_from_chunk ||= chunk[:headers]
      end

      def stop_process?
        @stop_process ||= false
      end

      def stop_process!
        @stop_process = true
      end

      private

      def process_action!
        return if stop_process?

        action_caller = Logux::ActionCaller.new(action: action_from_chunk,
                                                meta: meta_from_chunk,
                                                headers: headers_from_chunk)
        stream.write(action_caller.call!.format)
      end

      def process_authorization!
        policy_caller = Logux::PolicyCaller.new(action: action_from_chunk,
                                                meta: meta_from_chunk,
                                                headers: headers_from_chunk)
        policy_check = policy_caller.call!
        status = policy_check ? :approved : :forbidden
        stream.write({ answer: status, id: meta_from_chunk.id })
        return stream.write(',') if policy_check
        return if policy_check

        stop_process!
      end

      def process_resend!
        resender = Logux::Resender.new(action: action_from_chunk,
                                       meta: meta_from_chunk,
                                       headers: headers_from_chunk)

        resend_data = resender.call!
        return unless resend_data.present?

        stream.write(resend_data)
        stream.write(',')
      end
    end
  end
end
