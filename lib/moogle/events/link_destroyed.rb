require 'aequitas'
require 'serf/message'
require 'serf/more/uuid_fields'
require 'virtus'

module Moogle
module Events

  class LinkDestroyed
    include Virtus
    include Aequitas
    include Serf::Message
    include Serf::More::UuidFields

    attribute :link_id, Object

    validates_presence_of :link_id
  end

end
end
