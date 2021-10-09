# frozen_string_literal: true

require 'spec_helper'

describe Logux::Utils do
  describe '#underscore' do
    subject(:klass) { Class.new { include Logux::Utils }.new }

    context 'with unscoped class name' do
      it { expect(klass.underscore('HelloWorld')).to eq('hello_world') }
    end

    context 'with scoped class name' do
      it { expect(klass.underscore('Hello::World')).to eq('hello/world') }
    end
  end
end
