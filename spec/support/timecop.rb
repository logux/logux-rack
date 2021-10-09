# frozen_string_literal: true

require 'spec_helper'

shared_context timecop: true do
  around do |example|
    Timecop.freeze(Time.parse('13-06-2018 12:00'))
    example.call
    Timecop.return
  end
end
