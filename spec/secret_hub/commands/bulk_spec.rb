require 'spec_helper'

describe 'bin/secrethub bulk' do
  subject { CLI.router }
  let(:config_file) { 'tmp/secrets.yml' }

  context "without arguments" do
    it "shows short usage" do
      expect { subject.run %w[bulk]}.to output_fixture('cli/bulk/usage')
    end
  end

  context "with --help" do
    it "shows long usage" do
      expect { subject.run %w[bulk --help] }.to output_fixture('cli/bulk/help')
    end
  end

  describe "init" do
    before { system "rm -f #{config_file}" }

    it "creates a sample configuration file" do
      expect { subject.run %W[bulk init #{config_file}] }.to output_fixture('cli/bulk/init')
      expect(File).to exist(config_file)
      expect(File.read config_file).to match_fixture('cli/bulk/init-file')
    end
  end

  describe "list" do
    before { reset_tmp_dir }

    it "shows all secrets for the configured repos" do
      expect { subject.run %W[bulk list #{config_file}] }.to output_fixture('cli/bulk/list')
    end
  end

  describe "show" do
    before { reset_tmp_dir }

    it "shows the local configuration file and obfuscated secrets" do
      expect { subject.run %W[bulk show #{config_file}] }.to output_fixture('cli/bulk/show')
    end

    describe "--visible" do
      it "shows the local configuration file and revealed secrets" do
        expect { subject.run %W[bulk show #{config_file} --visible] }.to output_fixture('cli/bulk/show-visible')
      end      
    end
  end

  describe "save" do
    before { reset_tmp_dir }

    it "updates all secrets for the configured repos" do
      expect { subject.run %W[bulk save #{config_file}] }.to output_fixture('cli/bulk/save')
    end

    describe "--clean" do
      it "also deletes keys that are not configured" do
        expect { subject.run %W[bulk save #{config_file} --clean] }.to output_fixture('cli/bulk/save-clean')
      end
    end

    describe "--dry" do
      it "shows but does not save anything" do
        expect_any_instance_of(GitHubClient).not_to receive(:put_secret)
        expect_any_instance_of(GitHubClient).not_to receive(:delete_secret)
        expect { subject.run %W[bulk save #{config_file} --clean --dry] }.to output_fixture('cli/bulk/save-dry')
      end
    end
  end

  describe "clean" do
    before { reset_tmp_dir }

    it "deletes keys that are not configured" do
      expect { subject.run %W[bulk clean #{config_file}] }.to output_fixture('cli/bulk/clean')
    end

    describe "--dry" do
      it "shows but does not clean anything" do
        expect_any_instance_of(GitHubClient).not_to receive(:delete_secret)
        expect { subject.run %W[bulk clean #{config_file} --dry] }.to output_fixture('cli/bulk/clean-dry')
      end
    end
  end
end
