require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/models'
require 'moogle/messages/events/link_unsuspended'

module Moogle
module Commands

  class UnsuspendLink < Moogle::Commands::UpdateLink

    def call
      @options[:event_class] ||= Moogle::Events::LinkUnsuspended
      super
    end

    protected

    def update_params
      { suspended: false }
    end

  end

end
end
