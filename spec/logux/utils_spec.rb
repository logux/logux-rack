# frozen_string_literal: true

require 'spec_helper'

describe Logux::Utils do
  describe '.underscore' do
    using described_class

    let(:class_name) { 'HelloWorld' }
    let(:scoped_name) { 'Hello::World' }

    it 'underscores camel-cased class name' do
      expect(class_name.underscore).to eq('hello_world')
    end

    it 'can process scoped class name' do
      expect(scoped_name.underscore).to eq('hello/world')
    end
  end
end
