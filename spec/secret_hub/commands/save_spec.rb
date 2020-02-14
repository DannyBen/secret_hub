require 'spec_helper'

describe 'bin/secrethub save' do
  subject { CLI.router }

  context "without arguments" do
    it "shows short usage" do
      expect { subject.run %w[save]}.to output_fixture('cli/save/usage')
    end
  end

  context "with --help" do
    it "shows long usage" do
      expect { subject.run %w[save --help] }.to output_fixture('cli/save/help')
    end
  end

  context "with required arguments" do
    it "saves the secret" do
      expect { subject.run %w[save matz/ruby PASSWORD p4ssw0rd] }.to output_fixture('cli/save/ok')
    end
  end
end
