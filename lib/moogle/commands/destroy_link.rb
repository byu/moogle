require 'hashie'
require 'serf/command'
require 'serf/util/uuidable'

require 'moogle/error'
require 'moogle/models'

module Moogle
module Commands

  class DestroyLink
    include Serf::Command

    def call
      link_model = opts :link_model, Moogle::Link

      link_id = request.link_id
      link = link_model.get link_id

      # We only attempt to destroy the link if it exists.
      # We raise an error if we are unable to destroy an existing link.
      raise 'Unable to destroy link' unless link.destroy if link

      event = Hashie::Mash.new(
        kind: 'moogle/events/link_destroyed',
        link_id: link_id)
      Serf::Util::Uuidable.annotate_with_uuids! event, request
      return event
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
