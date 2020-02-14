require 'mister_bin'
require 'colsole'
require 'lp'

require 'secret_hub/github_client'

module SecretHub
  module Commands
    class Base < MisterBin::Command
      include Colsole

      def github
        @github ||= GitHubClient.new
      end

    end
  end
end