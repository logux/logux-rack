# frozen_string_literal: true

require 'spec_helper'

describe 'rake logux:actions' do
  subject(:task) { -> { Rake::Task[task_name].invoke(path) } }

  include_context 'with rake'

  let(:path) { "#{Dir.pwd}/**/dummy/logux/actions" }
  let(:actions_list) do
    [
      "   action.type Class#method\n",
      "blog/notes/add Actions::Blog::Notes#add\n",
      "   comment/add Actions::Comment#add\n",
      "   post/rename Actions::Post#rename\n",
      "    post/touch Actions::Post#touch\n"
    ].join
  end

  it 'outputs all action types and corresponding class and method names' do
    expect { task.call }.to output(actions_list).to_stdout
  end
end
