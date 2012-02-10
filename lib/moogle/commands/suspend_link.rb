require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/models'

module Moogle
module Commands

  class SuspendLink < Moogle::Commands::UpdateLink

    protected

    def update_params
      { suspended: true }
    end

  end

end
end
