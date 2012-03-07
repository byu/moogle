require 'aequitas'
require 'serf/message'
require 'uuidtools'
require 'virtus'

module Moogle
module Requests

  class DestroyTarget
    include Virtus
    include Aequitas
    include Serf::Message

    attribute :target_id, Integer

    attribute :uuid, String, default: lambda { |obj,attr|
      UUIDTools::UUID.random_create.to_s
    }

    validates_presence_of :target_id, :uuid

  end

end
end
