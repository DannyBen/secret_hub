module SecretHub
  module Commands
    class Repo < Base
      summary 'Manage repository secrets'

      usage 'secrethub repo list REPO'
      usage 'secrethub repo save REPO KEY [VALUE]'
      usage 'secrethub repo delete REPO KEY'
      usage 'secrethub repo (-h|--help)'

      command 'list', 'Show all repository secrets'
      command 'save', 'Create or update a repository secret'
      command 'delete', 'Delete a repository secret'

      param 'REPO', 'Full name of the GitHub repository (user/repo)'
      param 'KEY', 'The name of the secret'
      param 'VALUE', 'The plain text secret value. If not provided, it is expected to be set as an environment variable'

      example 'secrethub repo list me/myrepo'
      example 'secrethub repo save me/myrepo PASSWORD'
      example 'secrethub repo save me/myrepo PASSWORD s3cr3t'
      example 'secrethub repo delete me/myrepo PASSWORD'

      def list_command
        say "!txtblu!#{repo}:"
        github.secrets(repo).each do |secret|
          say "- !txtpur!#{secret}"
        end
      end

      def save_command
        github.put_secret repo, key, value
        say "Saved !txtblu!#{repo} !txtpur!#{key}"
      end

      def delete_command
        github.delete_secret repo, key
        say "Deleted !txtblu!#{repo} !txtpur!#{key}"
      end

    private

      def repo
        args['REPO']
      end

      def key
        args['KEY']
      end

      def value
        result = args['VALUE'] || ENV[key]
        unless result
          raise InvalidInput,
            "Please provide a value, either in the command line or in the environment variable '#{key}'"
        end

        result
      end
    end
  end
end
