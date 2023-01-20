module SecretHub
  module Commands
    class Org < Base
      summary 'Manage organization secrets'

      usage 'secrethub org list ORG'
      usage 'secrethub org save ORG KEY [VALUE]'
      usage 'secrethub org delete ORG KEY'
      usage 'secrethub org (-h|--help)'

      command 'list', 'Show all organization secrets'
      command 'save', 'Create or update an organization secret (with private repositories visibility)'
      command 'delete', 'Delete an organization secret'

      param 'ORG', 'Name of the organization'
      param 'KEY', 'The name of the secret'
      param 'VALUE', 'The plain text secret value. If not provided, it is expected to be set as an environment variable'

      example 'secrethub org list myorg'
      example 'secrethub org save myorg PASSWORD'
      example 'secrethub org save myorg PASSWORD s3cr3t'
      example 'secrethub org delete myorg PASSWORD'

      def list_command
        say "b`#{org}`:"
        github.org_secrets(org).each do |secret|
          say "- m`#{secret}`"
        end
      end

      def save_command
        github.put_org_secret org, key, value
        say "Saved b`#{org}` m`#{key}`"
      end

      def delete_command
        github.delete_org_secret org, key
        say "Deleted b`#{org}` m`#{key}`"
      end

    private

      def org
        args['ORG']
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
