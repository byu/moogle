require 'serf/command'

require 'moogle/error'
require 'moogle/representers/target_representer'
require 'moogle/requests/find_targets'
require 'moogle/models'

module Moogle
module Commands

  class FindTargets < Serf::Command

    def call
      target_model = opts :target_model, Moogle::Target
      representer = opts :representer, Moogle::TargetRepresenter

      targets = target_model.all owner_ref: request.owner_ref

      return targets.map{ |t| t.extend representer }
    rescue => e
      e.extend Moogle::Error
      raise e
    end

    protected

    def request_parser
      opts :request_parser, Moogle::Requests::FindTargets
    end

  end

end
end
