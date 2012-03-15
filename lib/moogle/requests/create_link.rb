require 'aequitas'
require 'serf/message'
require 'virtus'

require 'moogle/util/uuid_fields'

module Moogle
module Requests

  class CreateLink
    include Virtus
    include Aequitas
    include Serf::Message
    include Moogle::Util::UuidFields

    attribute :target_id, Integer
    attribute :receiver_ref, String
    attribute :message_kind, String

    validates_presence_of :target_id, :receiver_ref, :message_kind

  end

end
end
