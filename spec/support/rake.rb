# frozen_String_literal: true

require 'spec_helper'

shared_context 'with rake' do
  let(:tasks_path) { File.expand_path('../../lib/tasks', __dir__) }
  let(:task_name) { self.class.top_level_description.sub(/\Arake /, '') }

  before do
    Dir[File.join(tasks_path, '*.rake')].each do |file_name|
      base_name = File.basename(file_name, '.rake')
      Rake.application.rake_require(base_name, [tasks_path])
    end
  end
end
