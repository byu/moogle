require 'aequitas'
require 'serf/message'
require 'serf/more/uuid_fields'
require 'virtus'

module Moogle
module Requests

  class DestroyLink
    include Virtus
    include Aequitas
    include Serf::Message
    include Serf::More::UuidFields

    attribute :link_id, Integer

    validates_presence_of :link_id

  end

end
end
