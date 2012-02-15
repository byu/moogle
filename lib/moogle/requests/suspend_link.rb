require 'aequitas'
require 'serf/message'
require 'uuidtools'
require 'virtus'

module Moogle
module Requests

  class SuspendLink
    include Virtus
    include Aequitas
    include Serf::Message

    attribute :link_id, Integer

    attribute :uuid, String, :default => lambda { |obj,attr|
      UUIDTools::UUID.random_create.to_s
    }

    validates_presence_of :link_id

  end

end
end
