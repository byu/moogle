require 'aequitas'
require 'serf/message'
require 'serf/more/uuid_fields'
require 'virtus'

module Moogle
module Requests

  class CreateLink
    include Virtus
    include Aequitas
    include Serf::Message
    include Serf::More::UuidFields

    attribute :target_id, Integer
    attribute :receiver_ref, String
    attribute :message_kind, String

    validates_presence_of :target_id, :receiver_ref, :message_kind

  end

end
end
