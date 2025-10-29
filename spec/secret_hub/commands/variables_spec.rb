require 'spec_helper'

describe 'Variables commands' do
  context 'with repository variables' do
    let(:cli) { SecretHub::CLI.runner }
    let(:repo) { 'matz/ruby' }
    let(:key) { 'API_URL' }
    let(:value) { 'https://api.example.com' }

    describe 'list' do
      it 'shows all variables for the specified repository' do
        expect { cli.run %W[repo list variables #{repo}] }
          .to output_approval('cli/repo/list/variables')
      end
    end

    describe 'save' do
      it 'creates a new variable' do
        expect { cli.run %W[repo save variables #{repo} #{key} #{value}] }
          .to output_approval('cli/repo/save/variables')
      end

      it 'updates an existing variable' do
        expect { cli.run %W[repo save variables #{repo} #{key} #{value}] }
          .to output_approval('cli/repo/save/variables')
      end
    end

    describe 'delete' do
      it 'deletes a variable' do
        expect { cli.run %W[repo delete variables #{repo} #{key}] }
          .to output_approval('cli/repo/delete/variables')
      end
    end
  end

  context 'with organization variables' do
    let(:cli) { SecretHub::CLI.runner }
    let(:org) { 'matz' }
    let(:key) { 'API_URL' }
    let(:value) { 'https://api.example.com' }

    describe 'list' do
      it 'shows all variables for the specified organization' do
        expect { cli.run %W[org list variables #{org}] }
          .to output_approval('cli/org/list/variables')
      end
    end

    describe 'save' do
      it 'creates a new variable' do
        expect { cli.run %W[org save variables #{org} #{key} #{value}] }
          .to output_approval('cli/org/save/variables')
      end
    end

    describe 'delete' do
      it 'deletes a variable' do
        expect { cli.run %W[org delete variables #{org} #{key}] }
          .to output_approval('cli/org/delete/variables')
      end
    end
  end

  context 'with bulk variables' do
    let(:cli) { SecretHub::CLI.runner }
    let(:config_file) { 'spec/fixtures/variables.yml' }
    
    before { reset_tmp_dir }

    describe 'list' do
      it 'shows all variables for the configured repos' do
        expect { cli.run %W[bulk list variables #{config_file}] }
          .to output_approval('cli/bulk/list/variables')
      end
    end

    describe 'save' do
      it 'updates all variables for the configured repos' do
        expect { cli.run %W[bulk save variables #{config_file}] }
          .to output_approval('cli/bulk/save/variables')
      end

      describe '--clean' do
        it 'also removes variables that are not in the config' do
          expect { cli.run %W[bulk save variables #{config_file} --clean] }
            .to output_approval('cli/bulk/save/variables-clean')
        end
      end

      describe '--dry' do
        it 'shows what would have happened' do
          expect { cli.run %W[bulk save variables #{config_file} --dry] }
            .to output_approval('cli/bulk/save/variables-dry')
        end
      end

      describe '--only' do
        it 'saves variables to a single repository' do
          expect { cli.run %W[bulk save variables #{config_file} --only matz/ruby] }
            .to output_approval('cli/bulk/save/variables-only')
        end
      end
    end

    describe 'clean' do
      it 'removes variables that are not in the config' do
        expect { cli.run %W[bulk clean variables #{config_file}] }
          .to output_approval('cli/bulk/clean/variables')
      end
    end
  end
end
