# frozen_string_literal: true

module Logux
  module Test
    class StreamIO < StringIO
      def close; end
    end
  end
end
