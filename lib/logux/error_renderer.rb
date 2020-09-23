# frozen_string_literal: true

module Logux
  class ErrorRenderer
    attr_reader :exception

    def initialize(exception)
      @exception = exception
    end

    def message
      case exception
      when UnknownActionError, UnknownChannelError
        [action_response, exception.meta.id]
      when Logux::WithMetaError
        ['error', exception.meta.id, stacktrace]
      when StandardError
        ['error', stacktrace]
      end
    end

    private

    def stacktrace
      if Logux.configuration.render_backtrace_on_error
        [exception.message, exception.backtrace&.join("\n")].compact.join("\n")
      else
        'Please check server logs for more information'
      end
    end

    def action_response
      exception.class.name.demodulize.camelize(:lower).gsub(/Error/, '')
    end
  end
end
