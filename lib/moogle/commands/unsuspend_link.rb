require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/models'

module Moogle
module Commands

  class UnsuspendLink < Moogle::Commands::UpdateLink

    protected

    def update_params
      { suspended: false }
    end

  end

end
end
