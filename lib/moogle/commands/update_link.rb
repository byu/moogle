require 'serf/command'

require 'moogle/error'
require 'moogle/events/link_updated'
require 'moogle/requests/update_link'
require 'moogle/models'

module Moogle
module Commands

  class UpdateLink < Serf::Command

    def call
      link_model = @opts[:link_model] || Moogle::Link
      event_class = @opts[:event_class] || Moogle::Events::LinkUpdated
      representer = @opts[:representer] || Moogle::LinkRepresenter

      link = link_model.get @request.link_id
      raise '404 Not found' unless link

      link.update update_params
      raise link.errors.full_messages.join('; ') unless link.saved?

      link_rep = link.dup.extend representer
      return event_class.new(
        request_uuid: @request.uuid,
        link: link)
    rescue => e
      e.extend Moogle::Error
      raise e
    end

    protected

    def update_params
      { render_options: @request.render_options }
    end

    def request_parser
      @opts[:request_parser] || Moogle::Requests::UpdateLink
    end

  end

end
end
