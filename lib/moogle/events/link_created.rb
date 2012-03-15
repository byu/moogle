require 'aequitas'
require 'serf/message'
require 'serf/more/uuid_fields'
require 'virtus'

module Moogle
module Events

  class LinkCreated
    include Virtus
    include Aequitas
    include Serf::Message
    include Serf::More::UuidFields

    attribute :link, Object

    validates_presence_of :link
  end

end
end
