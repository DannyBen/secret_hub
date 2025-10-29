require 'fileutils'
require 'secret_hub/refinements/string_obfuscation'

module SecretHub
  module Commands
    class Bulk < Base
      using StringObfuscation

      summary 'Manage multiple secrets and variables in multiple repositories'

      usage 'secrethub bulk init [CONFIG]'
      usage 'secrethub bulk show [CONFIG --visible]'
      usage 'secrethub bulk list secrets [CONFIG]'
      usage 'secrethub bulk list variables [CONFIG]'
      usage 'secrethub bulk save secrets [CONFIG --clean --dry --only REPO]'
      usage 'secrethub bulk save variables [CONFIG --clean --dry --only REPO]'
      usage 'secrethub bulk clean secrets [CONFIG --dry]'
      usage 'secrethub bulk clean variables [CONFIG --dry]'
      usage 'secrethub bulk (-h|--help)'

      command 'init', 'Create a sample configuration file in the current directory'
      command 'show', 'Show the configuration file'
      command 'save', 'Save multiple secrets or variables to multiple repositories'
      command 'clean', 'Delete secrets or variables from multiple repositories unless they are specified in the config file'
      command 'list', 'Show all secrets or variables in all repositories'

      option '-c, --clean', 'Also delete any other secret or variable not defined in the configuration file'
      option '-v, --visible', 'Also show values'
      option '-d, --dry', 'Dry run'
      option '-o, --only REPO', 'Save all secrets or variables to a single repository from the configuration file'

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
        say "Saved g`#{config_file}`"
      end

      def show_command
        config.each do |repo, secrets|
          say "b`#{repo}`:"
          secrets.each do |key, value|
            show_secret key, value, args['--visible']
          end
        end
      end

      def list_command
        config.each_repo do |repo|
          say "b`#{repo}`:"
          items = case type
                 when 'secrets'
                   github.secrets(repo)
                 when 'variables'
                   github.variables(repo)
                 end
          items.each do |item|
            say "- m`#{item}`"
          end
        end
      end

      def save_command
        dry = args['--dry']
        only = args['--only']
        skipped = 0

        config.each do |repo, items|
          next if only && (repo != only)

          say "b`#{repo}`"
          skipped += update_repo repo, items, dry
          clean_repo repo, items.keys, dry if args['--clean']
        end

        puts "\n" if skipped.positive? || dry
        say "Skipped #{skipped} missing #{type}" if skipped.positive?
        say 'Dry run, nothing happened' if dry
      end

      def clean_command
        dry = args['--dry']

        config.each do |repo, items|
          say "b`#{repo}`"
          clean_repo repo, items.keys, dry
        end

        say "\nDry run, nothing happened" if dry
      end

    private

      def clean_repo(repo, keys, dry)
        repo_items = case type
                    when 'secrets'
                      github.secrets(repo)
                    when 'variables'
                      github.variables(repo)
                    end
        delete_candidates = repo_items - keys

        delete_candidates.each do |key|
          say "delete  m`#{key}`  "
          case type
          when 'secrets'
            github.delete_secret(repo, key) unless dry
          when 'variables'
            github.delete_variable(repo, key) unless dry
          end
          say 'g`OK`'
        end
      end

      def update_repo(repo, items, dry)
        skipped = 0

        items.each do |key, value|
          say "save    m`#{key}`  "
          if value
            begin
              case type
              when 'secrets'
                github.put_secret(repo, key, value) unless dry
              when 'variables'
                github.put_variable(repo, key, value) unless dry
              end
              say 'g`OK`'
            rescue APIError => e
              if e.message.include?('409') && e.message.include?('Already exists')
                say 'y`SKIPPED` (already exists)'
                skipped += 1
              else
                raise
              end
            end
          else
            say 'r`MISSING`'
            skipped += 1
          end
        end

        skipped
      end

      def show_secret(key, value, visible)
        if value
          value = value.obfuscate unless visible
          say "  m`#{key}`: c`#{value}`"
        else
          say "  m`#{key}`: r`*MISSING*`"
        end
      end

      def type
        return 'secrets' if args['secrets']
        return 'variables' if args['variables']
        raise InvalidInput, "Please specify either 'secrets' or 'variables'"
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
