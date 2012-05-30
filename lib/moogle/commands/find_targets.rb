require 'hashie'
require 'serf/command'
require 'serf/util/uuidable'

require 'moogle/error'
require 'moogle/representers/target_representer'
require 'moogle/models'

module Moogle
module Commands

  class FindTargets
    include Serf::Command

    def initialize(*args)
      extract_options! args
    end

    def call(request, context=nil)
      target_model = opts :target_model, Moogle::Target
      representer = opts :representer, Moogle::TargetRepresenter

      targets = target_model.all owner_ref: request.owner_ref

      return targets.map{ |t| Hashie::Mash.new(t.extend(representer).to_hash) }
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
