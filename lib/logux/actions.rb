# frozen_string_literal: true

module Logux
  class Actions < Action
    class << self
      extend Gem::Deprecate

      deprecate :new, 'Logux::Action.new', 2020, 9

      def warn(message)
        Logux.logger.warn(message)
      end
    end

    private_class_method :warn
  end
end
