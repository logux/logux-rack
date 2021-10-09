# frozen_string_literal: true

require 'spec_helper'

describe Logux::Actions do
  it { expect(described_class.new).to be_a(Logux::Action) }
end
