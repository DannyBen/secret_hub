module SecretHub
  module Commands
    class Repo < Base
      summary 'Manage repository secrets and variables'

      usage 'secrethub repo list secrets REPO'
      usage 'secrethub repo list variables REPO'
      usage 'secrethub repo save secrets REPO KEY [VALUE]'
      usage 'secrethub repo save variables REPO KEY [VALUE]'
      usage 'secrethub repo delete secrets REPO KEY'
      usage 'secrethub repo delete variables REPO KEY'
      usage 'secrethub repo (-h|--help)'

      command 'list', 'Show all repository secrets or variables'
      command 'save', 'Create or update a repository secret or variable'
      command 'delete', 'Delete a repository secret or variable'

      param 'REPO', 'Full name of the GitHub repository (user/repo)'
      param 'KEY', 'The name of the secret or variable'
      param 'VALUE', 'The plain text value. If not provided, it is expected to be set as an environment variable'

      example 'secrethub repo list secrets me/myrepo'
      example 'secrethub repo list variables me/myrepo'
      example 'secrethub repo save secrets me/myrepo PASSWORD s3cr3t'
      example 'secrethib repo save variables me/myrepo API_URL https://api.example.com'
      example 'secrethub repo delete secrets me/myrepo PASSWORD'
      example 'secrethub repo delete variables me/myrepo API_URL'

      def list_command
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

      def save_command
        begin
          case type
          when 'secrets'
            github.put_secret(repo, key, value)
          when 'variables'
            github.put_variable(repo, key, value)
          end
          say "Saved b`#{repo}` m`#{key}`"
        rescue APIError => e
          if e.message.include?('409') && e.message.include?('Already exists')
            say "Skipped b`#{repo}` m`#{key}` (already exists)"
          else
            raise
          end
        end
      end

      def delete_command
        case type
        when 'secrets'
          github.delete_secret(repo, key)
        when 'variables'
          github.delete_variable(repo, key)
        end
        say "Deleted b`#{repo}` m`#{key}`"
      end

    private

      def repo
        args['REPO']
      end

      def key
        args['KEY']
      end

      def type
        return 'secrets' if args['secrets']
        return 'variables' if args['variables']
        raise InvalidInput, "Please specify either 'secrets' or 'variables'"
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
