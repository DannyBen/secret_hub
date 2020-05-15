require 'spec_helper'

describe 'bin/secrethub org' do
  subject { CLI.router }

  context "without arguments" do
    it "shows short usage" do
      expect { subject.run %w[org]}.to output_fixture('cli/org/usage')
    end
  end

  context "with --help" do
    it "shows long usage" do
      expect { subject.run %w[org --help] }.to output_fixture('cli/org/help')
    end
  end

  describe "list" do
    it "shows list of secrets" do
      expect { subject.run %w[org list matz] }.to output_fixture('cli/org/list/ok')
    end
  end

  describe "save" do
    it "saves the secret" do
      expect { subject.run %w[org save matz PASSWORD p4ssw0rd] }.to output_fixture('cli/org/save/ok')
    end
  end

  describe "delete" do
    it "deletes the secret" do
      expect { subject.run %w[org delete matz PASSWORD] }.to output_fixture('cli/org/delete/ok')
    end
  end
end
