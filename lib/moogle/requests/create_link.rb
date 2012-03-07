require 'aequitas'
require 'serf/message'
require 'uuidtools'
require 'virtus'

module Moogle
module Requests

  class CreateLink
    include Virtus
    include Aequitas
    include Serf::Message

    attribute :target_id, Integer
    attribute :receiver_ref, String
    attribute :message_kind, String

    attribute :uuid, String, default: lambda { |obj,attr|
      UUIDTools::UUID.random_create.to_s
    }

    validates_presence_of :target_id, :receiver_ref, :message_kind, :uuid

  end

end
end
