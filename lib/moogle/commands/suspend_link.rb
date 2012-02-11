require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/models'
require 'moogle/messages/events/link_suspended'

module Moogle
module Commands

  class SuspendLink < Moogle::Commands::UpdateLink

    def call
      @options[:event_class] ||= Moogle::Events::LinkSuspended
      super
    end

    protected

    def update_params
      { suspended: true }
    end

  end

end
end
