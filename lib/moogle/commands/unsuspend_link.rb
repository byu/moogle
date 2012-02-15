require 'moogle/commands/update_link'
require 'moogle/error'
require 'moogle/events/link_unsuspended'
require 'moogle/requests/unsuspend_link'
require 'moogle/models'

module Moogle
module Commands

  class UnsuspendLink < Moogle::Commands::UpdateLink

    def call
      @opts[:event_class] ||= Moogle::Events::LinkUnsuspended
      super
    end

    protected

    def update_params
      { suspended: false }
    end

    def request_parser
      @opts[:request_parser] || Moogle::Requests::UnsuspendLink
    end

  end

end
end
