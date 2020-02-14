require 'spec_helper'

describe 'bin/secret_hub-list' do
  subject { CLI.router }

  context "without arguments" do
    it "shows short usage" do
      expect{ subject.run %w[list]}.to output_fixture('cli/list/usage')
    end
  end

  context "with --help" do
    it "shows long usage" do
      expect{ subject.run %w[list --help] }.to output_fixture('cli/list/help')
    end
  end

  context "with required arguments" do
    # Implement
  end
end
