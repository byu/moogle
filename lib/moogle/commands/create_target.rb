require 'active_support/core_ext/string/inflections'
require 'serf/command'

require 'moogle/error'
require 'moogle/events/target_created'
require 'moogle/requests/create_target'
require 'moogle/models'
require 'moogle/representers/target_representer'

module Moogle
module Commands

  class CreateTarget
    include Serf::Command

    self.request_factory = Moogle::Requests::CreateTarget

    ##
    # @return [Moogle::Target] the created target, properly subclassed by type.
    #
    def call
      event_class = opts :event_class, Moogle::Events::TargetCreated
      representer = opts :representer, Moogle::TargetRepresenter

      # Determine our model class name, and get the constant.
      model_name = "moogle/#{request.type}_target".classify
      target_model = model_name.constantize rescue Moogle::Target

      # Now, create the target, and raise on errors.
      target = target_model.create(
        owner_ref:  request.owner_ref,
        options: request.options)
      raise target.errors.full_messages.join('. ') unless target.saved?

      target_rep = target.dup.extend representer
      return event_class.new(
        request.create_child_uuids.merge(target: target_rep))
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
