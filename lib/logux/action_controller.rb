# frozen_string_literal: true

module Logux
  class ActionController < Logux::BaseController
    def resend(targets)
      return unless resending.present?

      resending.call(targets)
    end
  end
end
