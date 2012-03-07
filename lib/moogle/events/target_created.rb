require 'aequitas'
require 'serf/message'
require 'uuidtools'
require 'virtus'

module Moogle
module Events

  class TargetCreated
    include Virtus
    include Aequitas
    include Serf::Message

    attribute :target, Object
    attribute :request_uuid, String
    attribute :uuid, String, default: lambda { |obj,attr|
      UUIDTools::UUID.random_create.to_s
    }

    validates_presence_of :target, :request_uuid, :uuid

  end

end
end
