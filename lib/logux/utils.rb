# frozen_string_literal: true

module Logux
  module Utils
    def underscore(string)
      return string unless /[A-Z-]|::/.match?(string)

      String.new(string)
        .gsub('::', '/')
        .gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
    end
  end
end
