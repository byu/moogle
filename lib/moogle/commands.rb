require 'moogle/commands/create_link'
require 'moogle/commands/create_target'
require 'moogle/commands/destroy_link'
require 'moogle/commands/destroy_target'
require 'moogle/commands/find_targets'
require 'moogle/commands/update_target'

module Moogle

  ##
  # Just a lookup helper to get the command class from the message kind
  # in an ENV hash.
  #
  class CommandFinder

    ##
    # Our explicit map of message kinds to commands.
    #
    COMMAND_MESSAGE_MAP = {
      'moogle/requests/create_link' => Moogle::Commands::CreateLink,
      'moogle/requests/create_target' => Moogle::Commands::CreateTarget,
      'moogle/requests/destroy_link' => Moogle::Commands::DestroyLink,
      'moogle/requests/destroy_target' => Moogle::Commands::DestroyTarget,
      'moogle/requests/find_targets' => Moogle::Commands::FindTargets,
      'moogle/requests/update_target' => Moogle::Commands::UpdateTarget
    }

    def self.call(env={})
      command = COMMAND_MESSAGE_MAP[env[:kind]]
      raise "Command for Request '#{env[:kind]}' Not Found." unless command
      return command
    end
  end

end
