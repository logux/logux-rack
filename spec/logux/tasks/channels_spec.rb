# frozen_string_literal: true

require 'spec_helper'

describe 'rake logux:channels' do
  include_context 'with rake'

  subject(:task) { -> { Rake::Task[task_name].invoke(path) } }

  let(:path) { "#{Dir.pwd}/**/dummy/app/logux" }

  let(:channels_list) do
    [
      "channel Class\n",
      "   post Channels::Post\n"
    ].join
  end

  it 'outputs all channels and corresponding class names' do
    expect { task.call }.to output(channels_list).to_stdout
  end
end
