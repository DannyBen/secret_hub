require 'spec_helper'

describe 'bin/secret_hub' do
  subject { CLI.router }

  it 'shows list of commands' do
    expect { subject.run }.to output_approval('cli/commands')
  end

  context 'when an exception occurs' do
    it 'errors gracefully' do
      expect(`bin/secrethub repo list guido/python 2>&1`).to match_approval('cli/exception')
    end
  end
end
