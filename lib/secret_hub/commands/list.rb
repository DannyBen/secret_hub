module SecretHub
  module Commands
    class List < Base
      summary "Show secrets for a repository"

      usage "secrethub list REPO"
      usage "secrethub list (-h|--help)"

      param "REPO", "Full name of the GitHub repository (user/repo)"

      example "secrethub list bob/repo-woth-secrets"

      def run
        repo = args['REPO']
        say "!txtblu!#{repo}"
        github.secrets(repo).each do |secret|
          say "!txtpur!#{secret}"
        end
      end
    end
  end
end
