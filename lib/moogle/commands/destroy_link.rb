require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/messages/events/link_destroyed'
require 'moogle/messages/requests/destroy_link'
require 'moogle/models'

module Moogle
module Commands

  class DestroyLink < Moogle::Commands::BaseCommand

    def call
      link_model = @opts[:link_model] || Moogle::Link
      event_class = @opts[:event_class] || Moogle::Events::LinkDestroyed

      link_id = @request.link_id
      link = link_model.get link_id

      # We only attempt to destroy the link if it exists.
      # We raise an error if we are unable to destroy an existing link.
      raise 'Unable to destroy link' unless link.destroy if link

      return event_class.new(
        request_uuid: @request.uuid,
        link_id: link_id)
    rescue => e
      e.extend Moogle::Error
      raise e
    end

    protected

    def request_parser
      @opts[:request_parser] || Moogle::Requests::DestroyLink
    end

  end

end
end
