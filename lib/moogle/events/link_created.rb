require 'aequitas'
require 'serf/message'
require 'virtus'

require 'moogle/util/uuid_fields'

module Moogle
module Events

  class LinkCreated
    include Virtus
    include Aequitas
    include Serf::Message
    include Moogle::Util::UuidFields

    attribute :link, Object

    validates_presence_of :link
  end

end
end
