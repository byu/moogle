require 'hashie'
require 'serf/command'
require 'serf/util/uuidable'

require 'moogle/error'
require 'moogle/models'

module Moogle
module Commands

  class DestroyTarget
    include Serf::Command

    def initialize(*args)
      extract_options! args
    end

    def call(request, context=nil)
      target_model = opts :target_model, Moogle::Target

      target_id = request.target_id
      target = target_model.get target_id

      # We only attempt to destroy the link if it exists.
      # We raise an error if we are unable to destroy an existing link.
      raise 'Unable to destroy target' unless target.destroy if target

      event = Hashie::Mash.new(
        kind: 'moogle/events/target_destroyed',
        target_id: target_id)
      Serf::Util::Uuidable.annotate_with_uuids! event, request
      return event
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
