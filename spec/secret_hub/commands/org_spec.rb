require 'spec_helper'

describe Commands::Org do
  context 'without arguments' do
    it 'shows short usage' do
      expect { subject.execute %w[org] }.to output_approval('cli/org/usage')
    end
  end

  context 'with --help' do
    it 'shows long usage' do
      expect { subject.execute %w[org --help] }.to output_approval('cli/org/help')
    end
  end

  describe 'list ORG' do
    it 'shows list of secrets' do
      expect { subject.execute %w[org list matz] }.to output_approval('cli/org/list/ok')
    end
  end

  describe 'save ORG KEY VALUE' do
    it 'saves the secret' do
      expect { subject.execute %w[org save matz PASSWORD p4ssw0rd] }.to output_approval('cli/org/save/ok')
    end
  end

  describe 'save ORG KEY' do
    context 'when the value exists in the environemnt' do
      before { ENV['PASSWORD'] = 's3cr3tz' }
      after { ENV['PASSWORD'] = nil }

      it 'saves the secret' do
        expect { subject.execute %w[org save matz PASSWORD] }.to output_approval('cli/org/save/ok')
      end
    end

    context 'when the value does not exist in the environemnt' do
      it 'raises InvalidInput' do
        expect { subject.execute %w[org save matz PASSWORD] }.to raise_error(InvalidInput)
      end
    end
  end

  describe 'delete ORG KEY' do
    it 'deletes the secret' do
      expect { subject.execute %w[org delete matz PASSWORD] }.to output_approval('cli/org/delete/ok')
    end
  end
end
