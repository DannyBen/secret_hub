require 'spec_helper'

describe 'bin/secrethub delete' do
  subject { CLI.router }

  context "without arguments" do
    it "shows short usage" do
      expect { subject.run %w[delete]}.to output_fixture('cli/delete/usage')
    end
  end

  context "with --help" do
    it "shows long usage" do
      expect { subject.run %w[delete --help] }.to output_fixture('cli/delete/help')
    end
  end

  context "with required arguments" do
    it "deletes the secret" do
      expect { subject.run %w[delete matz/ruby PASSWORD] }.to output_fixture('cli/delete/ok')
    end
  end
end
