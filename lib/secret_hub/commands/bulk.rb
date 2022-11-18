require 'fileutils'
require 'secret_hub/refinements/string_obfuscation'

module SecretHub
  module Commands
    class Bulk < Base
      using StringObfuscation

      summary 'Manage multiple secrets in multiple repositories'

      usage 'secrethub bulk init [CONFIG]'
      usage 'secrethub bulk show [CONFIG --visible]'
      usage 'secrethub bulk list [CONFIG]'
      usage 'secrethub bulk save [CONFIG --clean --dry --only REPO]'
      usage 'secrethub bulk clean [CONFIG --dry]'
      usage 'secrethub bulk (-h|--help)'

      command 'init', 'Create a sample configuration file in the current directory'
      command 'show', 'Show the configuration file'
      command 'save', 'Save multiple secrets to multiple repositories'
      command 'clean', 'Delete secrets from multiple repositories unless they are specified in the config file'
      command 'list', 'Show all secrets in all repositories'

      option '-c, --clean', 'Also delete any other secret not defined in the configuration file'
      option '-v, --visible', 'Also show secret values'
      option '-d, --dry', 'Dry run'
      option '-o, --only REPO', 'Save all secrets to a single repository from the configuration file'

      param 'CONFIG', 'Path to the configuration file [default: secrethub.yml]'

      example 'secrethub bulk init'
      example 'secrethub bulk show --visible'
      example 'secrethub bulk clean'
      example 'secrethub bulk list mysecrets.yml'
      example 'secrethub bulk save mysecrets.yml --dry'
      example 'secrethub bulk save --clean'
      example 'secrethub bulk save --only me/my-important-repo'

      def init_command
        raise SecretHubError, "File #{config_file} already exists" if File.exist? config_file

        FileUtils.cp config_template, config_file
        say "!txtgrn!Saved #{config_file}"
      end

      def show_command
        config.each do |repo, secrets|
          say "!txtblu!#{repo}:"
          secrets.each do |key, value|
            show_secret key, value, args['--visible']
          end
        end
      end

      def list_command
        config.each_repo do |repo|
          say "!txtblu!#{repo}:"
          github.secrets(repo).each do |secret|
            say "- !txtpur!#{secret}"
          end
        end
      end

      def save_command
        dry = args['--dry']
        only = args['--only']
        skipped = 0

        config.each do |repo, secrets|
          next if only && (repo != only)

          say "!txtblu!#{repo}"
          skipped += update_repo repo, secrets, dry
          clean_repo repo, secrets.keys, dry if args['--clean']
        end

        puts "\n" if skipped.positive? || dry
        say "Skipped #{skipped} missing secrets" if skipped.positive?
        say 'Dry run, nothing happened' if dry
      end

      def clean_command
        dry = args['--dry']

        config.each do |repo, secrets|
          say "!txtblu!#{repo}"
          clean_repo repo, secrets.keys, dry
        end

        say "\nDry run, nothing happened" if dry
      end

    private

      def clean_repo(repo, keys, dry)
        repo_keys = github.secrets repo
        delete_candidates = repo_keys - keys

        delete_candidates.each do |key|
          say "delete  !txtpur!#{key}  "
          github.delete_secret repo, key unless dry
          say '!txtgrn!OK'
        end
      end

      def update_repo(repo, secrets, dry)
        skipped = 0

        secrets.each do |key, value|
          say "save    !txtpur!#{key}  "
          if value
            github.put_secret repo, key, value unless dry
            say '!txtgrn!OK'
          else
            say '!txtred!MISSING'
            skipped += 1
          end
        end

        skipped
      end

      def show_secret(key, value, visible)
        if value
          value = value.obfuscate unless visible
          say "  !txtpur!#{key}: !txtcyn!#{value}"
        else
          say "  !txtpur!#{key}: !txtred!*MISSING*"
        end
      end

      def config_file
        args['CONFIG'] || 'secrethub.yml'
      end

      def config
        @config ||= Config.load config_file
      end

      def config_template
        File.expand_path '../config-template.yml', __dir__
      end
    end
  end
end
