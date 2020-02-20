require 'mister_bin'
require 'secret_hub/commands/base'
require 'secret_hub/commands/list'
require 'secret_hub/commands/save'
require 'secret_hub/commands/delete'
require 'secret_hub/commands/bulk'

module SecretHub
  class CLI
    def self.router
      router = MisterBin::Runner.new version: VERSION,
        header: "GitHub Secret Manager",
        footer: "Run !txtpur!secrethub COMMAND --help!txtrst! for command specific help"

      router.route 'list',   to: Commands::List
      router.route 'save',   to: Commands::Save
      router.route 'delete', to: Commands::Delete
      router.route 'bulk',   to: Commands::Bulk

      router
    end
  end

end
