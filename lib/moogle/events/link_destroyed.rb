require 'aequitas'
require 'serf/message'
require 'virtus'

require 'moogle/util/uuid_fields'

module Moogle
module Events

  class LinkDestroyed
    include Virtus
    include Aequitas
    include Serf::Message
    include Moogle::Util::UuidFields

    attribute :link_id, Object

    validates_presence_of :link_id
  end

end
end
