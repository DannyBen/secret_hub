module SecretHub
  module Commands
    class Save < Base
      summary "Create or update a secret in a repository"

      usage "secrethub save REPO KEY VALUE"
      usage "secrethub save (-h|--help)"

      param "REPO", "Full name of the GitHub repository (user/repo)"
      param "KEY", "The name of the secret"
      param "VALUE", "The plain text secret value"

      example "secrethub save bob/vault PASSWORD p4ssw0rd"

      def run
        repo = args['REPO']
        key = args['KEY']
        value = args['VALUE']
        
        success = github.put_secret repo, key, value
        say success ? "Saved !txtblu!#{repo} !txtgrn!#{key}" : "!txtred!ERROR: Failed saving secret"
      end
    end
  end
end
