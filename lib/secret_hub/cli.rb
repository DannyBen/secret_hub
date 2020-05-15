require 'mister_bin'
require 'secret_hub/commands/base'
require 'secret_hub/commands/repo'
require 'secret_hub/commands/bulk'
require 'secret_hub/commands/org'

module SecretHub
  class CLI
    def self.router
      router = MisterBin::Runner.new version: VERSION,
        header: "GitHub Secret Manager",
        footer: "Run !txtpur!secrethub COMMAND --help!txtrst! for command specific help"

      router.route 'repo',   to: Commands::Repo
      router.route 'org',    to: Commands::Org
      router.route 'bulk',   to: Commands::Bulk

      router
    end
  end

end
