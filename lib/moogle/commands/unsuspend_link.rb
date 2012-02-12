require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/messages/events/link_unsuspended'
require 'moogle/messages/requests/unsuspend_link'
require 'moogle/models'

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

    def request_parser
      @options[:request_parser] || Moogle::Requests::UnsuspendLink
    end

  end

end
end
