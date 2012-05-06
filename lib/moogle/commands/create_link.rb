require 'hashie'
require 'serf/command'
require 'serf/util/uuidable'

require 'moogle/error'
require 'moogle/models'
require 'moogle/representers/link_representer'

module Moogle
module Commands

  class CreateLink
    include Serf::Command

    def call
      link_model = opts :link_model, Moogle::Link
      target_model = opts :target_model, Moogle::Target
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

      event = Hashie::Mash.new(
        kind: 'moogle/events/link_created',
        link: link_rep.to_hash)
      Serf::Util::Uuidable.annotate_with_uuids! event, request
      return event
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
