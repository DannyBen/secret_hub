module SecretHub
  module Commands
    class Org < Base
      summary "Manage organization secrets"
      
      usage "secrethub org list ORG"
      usage "secrethub org save ORG KEY VALUE"
      usage "secrethub org delete ORG KEY"
      usage "secrethub org (-h|--help)"

      command "list", "Show all organization secrets"
      command "save", "Create or update an organization secret (with private repositories visibility)"
      command "delete", "Delete an organization secret"

      param "ORG", "Name of the organization"
      param "KEY", "The name of the secret"
      param "VALUE", "The plain text secret value"

      example "secrethub org list myorg"
      example "secrethub org save myorg PASSWORD s3cr3t"
      example "secrethub org delete myorg PASSWORD"

      def list_command
        say "!txtblu!#{org}:"
        github.org_secrets(org).each do |secret|
          say "- !txtpur!#{secret}"
        end
      end

      def save_command       
        github.put_org_secret org, key, value
        say "Saved !txtblu!#{org} !txtpur!#{key}"
      end

      def delete_command
        github.delete_org_secret org, key
        say "Deleted !txtblu!#{org} !txtpur!#{key}"
      end

    private

      def org
        args['ORG']
      end

      def key
        args['KEY']
      end

      def value
        args['VALUE']
      end

    end
  end
end