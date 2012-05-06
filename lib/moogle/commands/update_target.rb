require 'hashie'
require 'serf/command'
require 'serf/util/uuidable'

require 'moogle/error'
require 'moogle/models'

module Moogle
module Commands

  class UpdateTarget
    include Serf::Command

    def call
      target_model = opts :target_model, Moogle::Target
      representer = opts :representer, Moogle::TargetRepresenter

      target = target_model.get request.target_id
      raise '404 Not found' unless target

      result = target.update update_params
      raise target.errors.full_messages.join('; ') unless target.saved?

      target_rep = target.dup.extend representer

      event = Hashie::Mash.new(
        kind: 'moogle/events/target_updated',
        target: target_rep.to_hash)
      Serf::Util::Uuidable.annotate_with_uuids! event, request
      return event
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
