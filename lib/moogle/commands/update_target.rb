require 'serf/command'

require 'moogle/error'
require 'moogle/events/target_updated'
require 'moogle/requests/update_target'
require 'moogle/models'

module Moogle
module Commands

  class UpdateTarget
    include Serf::Command

    self.request_factory = Moogle::Requests::UpdateTarget

    def call
      target_model = opts :target_model, Moogle::Target
      event_class = opts :event_class, Moogle::Events::TargetUpdated
      representer = opts :representer, Moogle::TargetRepresenter

      target = target_model.get request.target_id
      raise '404 Not found' unless target

      result = target.update update_params
      raise target.errors.full_messages.join('; ') unless target.saved?

      target_rep = target.dup.extend representer

      return event_class.new request.create_child_uuids.merge(target: target)
    rescue => e
      e.extend Moogle::Error
      raise e
    end

    protected

    def update_params
      { options: request.options }
    end

  end

end
end
