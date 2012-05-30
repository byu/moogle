require 'active_support/core_ext/string/inflections'
require 'hashie'
require 'serf/command'
require 'serf/util/uuidable'

require 'moogle/error'
require 'moogle/models'
require 'moogle/representers/target_representer'

module Moogle
module Commands

  class CreateTarget
    include Serf::Command

    def initialize(*args)
      extract_options! args
    end

    ##
    # @return [Moogle::Target] the created target, properly subclassed by type.
    #
    def call(request, context=nil)
      representer = opts :representer, Moogle::TargetRepresenter

      # Determine our model class name, and get the constant.
      model_name = "moogle/#{request.type}_target".classify
      target_model = model_name.constantize rescue Moogle::Target

      # Now, create the target, and raise on errors.
      target = target_model.create(
        owner_ref:  request.owner_ref,
        options: (request.options || {}))
      raise target.errors.full_messages.join('. ') unless target.saved?

      target_rep = target.dup.extend representer

      event = Hashie::Mash.new(
        kind: 'moogle/events/target_created',
        target: target_rep.to_hash)
      Serf::Util::Uuidable.annotate_with_uuids! event, request
      return event
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
