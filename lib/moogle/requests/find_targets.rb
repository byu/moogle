require 'aequitas'
require 'serf/message'
require 'serf/more/uuid_fields'
require 'virtus'

module Moogle
module Requests

  class FindTargets
    include Virtus
    include Aequitas
    include Serf::Message
    include Serf::More::UuidFields

    attribute :owner_ref, String

    validates_presence_of :owner_ref
  end

end
end
