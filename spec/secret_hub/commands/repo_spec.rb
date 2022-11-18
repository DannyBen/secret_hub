require 'spec_helper'

describe 'bin/secrethub repo' do
  subject { CLI.router }

  context 'without arguments' do
    it 'shows short usage' do
      expect { subject.run %w[repo] }.to output_approval('cli/repo/usage')
    end
  end

  context 'with --help' do
    it 'shows long usage' do
      expect { subject.run %w[repo --help] }.to output_approval('cli/repo/help')
    end
  end

  describe 'list REPO' do
    it 'shows list of secrets' do
      expect { subject.run %w[repo list matz/ruby] }.to output_approval('cli/repo/list/ok')
    end
  end

  describe 'save REPO KEY' do
    context 'when the value exists in the environemnt' do
      before { ENV['PASSWORD'] = 's3cr3tz' }
      after { ENV['PASSWORD'] = nil }

      it 'saves the secret' do
        expect { subject.run %w[repo save matz/ruby PASSWORD] }.to output_approval('cli/repo/save/ok')
      end
    end

    context 'when the value does not exist in the environemnt' do
      it 'raises InvalidInput' do
        expect { subject.run %w[repo save matz/ruby PASSWORD] }.to raise_error(InvalidInput)
      end
    end
  end

  describe 'save REPO KEY VALUE' do
    it 'saves the secret' do
      expect { subject.run %w[repo save matz/ruby PASSWORD p4ssw0rd] }.to output_approval('cli/repo/save/ok')
    end
  end

  describe 'delete REPO KEY' do
    it 'deletes the secret' do
      expect { subject.run %w[repo delete matz/ruby PASSWORD] }.to output_approval('cli/repo/delete/ok')
    end
  end
end
