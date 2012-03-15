require 'aequitas'
require 'serf/message'
require 'virtus'

require 'moogle/util/uuid_fields'

module Moogle
module Requests

  class FindTargets
    include Virtus
    include Aequitas
    include Serf::Message
    include Moogle::Util::UuidFields

    attribute :owner_ref, String

    validates_presence_of :owner_ref
  end

end
end
