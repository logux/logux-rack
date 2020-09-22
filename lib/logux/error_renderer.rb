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
        [
          exception.class.name.demodulize.camelize(:lower).gsub(/Error/, ''),
          exception.meta.id
        ]
      when UnauthorizedError
        [exception.class.name.demodulize.camelize(:lower).gsub(/Error/, '')]
      when Logux::WithMetaError
        [
          'error',
          exception.meta.id,
          stacktrace(exception)
        ]
      when StandardError
        ['error', stacktrace(exception)]
      end
    end

    private

    def stacktrace(exception)
      if Logux.configuration.render_backtrace_on_error
        [exception.message, exception.backtrace&.join("\n")].compact.join("\n")
      else
        'Please check server logs for more information'
      end
    end
  end
end
