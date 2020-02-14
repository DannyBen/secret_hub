module SecretHub
  module Commands
    class Delete < Base
      summary "Delete a secret from a repository"

      usage "secrethub delete REPO KEY"
      usage "secrethub delete (-h|--help)"

      param "REPO", "Full name of the GitHub repository (user/repo)"
      param "KEY", "The name of the secret"

      example "secrethub delete bob/vault PASSWORD"

      def run
        repo = args['REPO']
        key = args['KEY']
        
        success = github.delete_secret repo, key
        say success ? "!txtgrn!Deleted" : "!txtred!ERROR: Failed deleting secret"
      end
    end
  end
end
