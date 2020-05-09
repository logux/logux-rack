# frozen_string_literal: true

module Logux
  class ErrorRenderer
    attr_reader :exception

    def initialize(exception)
      @exception = exception
    end

    def message
      case exception
      when Logux::WithMetaError
        build_message(exception, [exception.meta.id, backtrace(exception)])
      when Logux::UnauthorizedError
        build_message(exception, [exception.message])
      when StandardError
        # some runtime error that should be fixed
        ['error', backtrace(exception)]
      end
    end

    private

    def backtrace(exception)
      unless Logux.configuration.render_backtrace_on_error
        return 'Please check server logs for more information'
      end

      [exception.message, exception.backtrace].flatten.compact.join("\n")
    end

    def build_message(exception, additional_info)
      [
        exception.class.name.demodulize.camelize(:lower).gsub(/Error/, ''),
        *additional_info
      ]
    end
  end
end
