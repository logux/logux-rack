# frozen_string_literal: true

module Logux
  module Utils
    refine String do
      def underscore
        return self unless /[A-Z-]|::/.match?(self)

        String.new(self).tap do |word|
          word.gsub!('::', '/')
          word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
          word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
          word.tr!('-', '_')
          word.downcase!
        end
      end
    end
  end
end
