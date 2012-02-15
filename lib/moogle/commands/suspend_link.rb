require 'moogle/commands/update_link'
require 'moogle/error'
require 'moogle/events/link_suspended'
require 'moogle/requests/suspend_link'
require 'moogle/models'

module Moogle
module Commands

  class SuspendLink < Moogle::Commands::UpdateLink

    def call
      @opts[:event_class] ||= Moogle::Events::LinkSuspended
      super
    end

    protected

    def update_params
      { suspended: true }
    end

    def request_parser
      @opts[:request_parser] || Moogle::Requests::SuspendLink
    end

  end

end
end
