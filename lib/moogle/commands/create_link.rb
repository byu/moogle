require 'serf/command'

require 'moogle/error'
require 'moogle/events/link_created'
require 'moogle/requests/create_link'
require 'moogle/models'
require 'moogle/representers/link_representer'

module Moogle
module Commands

  class CreateLink < Serf::Command

    def call
      link_model = @opts[:link_model] || Moogle::Link
      target_model = @opts[:target_model] || Moogle::Target
      event_class = @opts[:event_class] || Moogle::Events::LinkCreated
      representer = @opts[:representer] || Moogle::LinkRepresenter

      target = target_model.get @request.target_id

      unless target
        raise '404 Not found target'
      end

      link = link_model.create(
        target: target,
        receiver_ref: @request.receiver_ref,
        message_kind: @request.message_kind,
        render_options: @request.render_options)
      raise link.errors.full_messages.join('. ') unless link.saved?

      link_rep = link.dup.extend representer
      event = event_class.new(
        request_uuid: @request.uuid,
        link: link_rep)
      return event
    rescue => e
      e.extend Moogle::Error
      raise e
    end

    protected

    def request_parser
      @opts[:request_parser] || Moogle::Requests::CreateLink
    end

  end

end
end
