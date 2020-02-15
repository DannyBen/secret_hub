require 'yaml'

module SecretHub
  module Commands
    class Bulk < Base
      summary "Update or delete multiple secrets from multiple repositories"
      
      usage "secrethub bulk init [CONFIG]"
      usage "secrethub bulk list [CONFIG]"
      usage "secrethub bulk save [CONFIG --clean]"
      usage "secrethub bulk clean [CONFIG]"
      usage "secrethub bulk (-h|--help)"

      command "init", "Create a sample configuration file in the current directory"
      command "save", "Save multiple secrets to multiple repositories"
      command "clean", "Delete secrets from multiple repositories unless they are specified in the config file"
      command "list", "Show all secrets in all repositories"

      option "-c, --clean", "Also delete any other secret not defined in the config file"

      param "CONFIG", "Path to the configuration file [default: secrethub.yml]"
            
      example "secrethub bulk init"
      example "secrethub bulk clean"
      example "secrethub bulk list mysecrets.yml"
      example "secrethub bulk save mysecrets.yml"
      example "secrethub bulk save --clean"

      def init_command
        raise SecretHubError, "File #{config_file} already exists" if File.exist? config_file

        content = {
          "user/repo" => %w[SECRET PASSWORD SECRET_KEY],
          "user/another-repo" => %w[SECRET SECRET_KEY],
        }

        File.write config_file, content.to_yaml
        say "!txtgrn!Saved #{config_file}"
      end

      def list_command
        config.each do |repo, keys|
          say "!txtblu!#{repo}:"
          github.secrets(repo).each do |secret|
            say "- !txtpur!#{secret}"
          end
        end
      end

      def save_command
        clean = args['--clean']

        config.each do |repo, keys|
          say "!txtblu!#{repo}"
          update_repo repo, keys
          clean_repo repo, keys if clean
        end
      end

      def clean_command
        config.each do |repo, keys|
          say "!txtblu!#{repo}"
          clean_repo repo, keys
        end
      end

    private

      def clean_repo(repo, keys)
        repo_keys = github.secrets repo
        delete_candidates = repo_keys - keys

        delete_candidates.each do |key|
          say "delete !txtpur!#{key} "
          success = github.delete_secret repo, key
          say "!txtgrn!OK"
        end
      end

      def update_repo(repo, keys)
        keys.each do |key|
          say "save   !txtpur!#{key} "
          github.put_secret repo, key, secret_value(key)
          say "!txtgrn!OK"
        end
      end

      def secret_value(key)
        ENV[key] || raise(EnvironmentError, "Please set the #{key} environment variable")
      end

      def config_file
        args['CONFIG'] || 'secrethub.yml'
      end

      def config
        raise ConfigurationError, "Config file not found #{config_flie}" unless File.exist? config_file
        result = YAML.load_file config_file
        result.transform_values { |v| v || [] }
      end
    end
  end
end
