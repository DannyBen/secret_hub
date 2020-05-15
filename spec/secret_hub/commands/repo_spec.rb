require 'spec_helper'

describe 'bin/secrethub repo' do
  subject { CLI.router }

  context "without arguments" do
    it "shows short usage" do
      expect { subject.run %w[repo]}.to output_fixture('cli/repo/usage')
    end
  end

  context "with --help" do
    it "shows long usage" do
      expect { subject.run %w[repo --help] }.to output_fixture('cli/repo/help')
    end
  end

  describe "list" do
    it "shows list of secrets" do
      expect { subject.run %w[repo list matz/ruby] }.to output_fixture('cli/repo/list/ok')
    end
  end

  describe "save" do
    it "saves the secret" do
      expect { subject.run %w[repo save matz/ruby PASSWORD p4ssw0rd] }.to output_fixture('cli/repo/save/ok')
    end
  end

  describe "delete" do
    it "deletes the secret" do
      expect { subject.run %w[repo delete matz/ruby PASSWORD] }.to output_fixture('cli/repo/delete/ok')
    end
  end
end
