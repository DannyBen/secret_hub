module SecretHub
  module Commands
    class Org < Base
      summary 'Manage organization secrets and variables'

      usage 'secrethub org list secrets ORG'
      usage 'secrethub org list variables ORG'
      usage 'secrethub org save secrets ORG KEY [VALUE]'
      usage 'secrethub org save variables ORG KEY [VALUE]'
      usage 'secrethub org delete secrets ORG KEY'
      usage 'secrethub org delete variables ORG KEY'
      usage 'secrethub org (-h|--help)'

      command 'list', 'Show all organization secrets or variables'
      command 'save', 'Create or update an organization secret or variable'
      command 'delete', 'Delete an organization secret or variable'

      param 'ORG', 'Name of the organization'
      param 'KEY', 'The name of the secret or variable'
      param 'VALUE', 'The plain text value. If not provided, it is expected to be set as an environment variable'

      example 'secrethub org list secrets myorg'
      example 'secrethub org list variables myorg'
      example 'secrethub org save secrets myorg PASSWORD s3cr3t'
      example 'secrethub org save variables myorg API_URL https://api.example.com'
      example 'secrethub org delete secrets myorg PASSWORD'
      example 'secrethub org delete variables myorg API_URL'

      def list_command
        say "b`#{org}`:"
        items = case type
               when 'secrets'
                 github.org_secrets(org)
               when 'variables'
                 github.org_variables(org)
               end
        items.each do |item|
          say "- m`#{item}`"
        end
      end

      def save_command
        begin
          case type
          when 'secrets'
            github.put_org_secret(org, key, value)
          when 'variables'
            github.put_org_variable(org, key, value)
          end
          say "Saved b`#{org}` m`#{key}`"
        rescue APIError => e
          if e.message.include?('409') && e.message.include?('Already exists')
            say "Skipped b`#{org}` m`#{key}` (already exists)"
          else
            raise
          end
        end
      end

      def delete_command
        case type
        when 'secrets'
          github.delete_org_secret(org, key)
        when 'variables'
          github.delete_org_variable(org, key)
        end
        say "Deleted b`#{org}` m`#{key}`"
      end

    private

      def org
        args['ORG']
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
