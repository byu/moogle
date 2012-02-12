require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/messages/events/link_suspended'
require 'moogle/messages/requests/suspend_link'
require 'moogle/models'

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

    def request_parser
      @options[:request_parser] || Moogle::Requests::SuspendLink
    end

  end

end
end
