require 'serf/command'

require 'moogle/error'
require 'moogle/events/target_destroyed'
require 'moogle/requests/destroy_target'
require 'moogle/models'

module Moogle
module Commands

  class DestroyTarget
    include Serf::Command

    self.request_factory = Moogle::Requests::DestroyTarget

    def call
      target_model = opts :target_model, Moogle::Target
      event_class = opts :event_class, Moogle::Events::TargetDestroyed

      target_id = request.target_id
      target = target_model.get target_id

      # We only attempt to destroy the link if it exists.
      # We raise an error if we are unable to destroy an existing link.
      raise 'Unable to destroy target' unless target.destroy if target

      return event_class.new(
        parent_uuid: request.uuid,
        target_id: target_id)
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
