require 'serf/command'

require 'moogle/error'
require 'moogle/events/link_created'
require 'moogle/requests/create_link'
require 'moogle/models'
require 'moogle/representers/link_representer'

module Moogle
module Commands

  class CreateLink
    include Serf::Command

    self.request_factory = Moogle::Requests::CreateLink

    def call
      link_model = opts :link_model, Moogle::Link
      target_model = opts :target_model, Moogle::Target
      event_class = opts :event_class, Moogle::Events::LinkCreated
      representer = opts :representer, Moogle::LinkRepresenter

      target = target_model.get request.target_id

      unless target
        raise '404 Not found target'
      end

      link = link_model.create(
        target: target,
        receiver_ref: request.receiver_ref,
        message_kind: request.message_kind)
      raise link.errors.full_messages.join('. ') unless link.saved?

      link_rep = link.dup.extend representer
      return event_class.new request.create_child_uuids.merge(link: link_rep)
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
