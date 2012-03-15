require 'aequitas'
require 'serf/message'
require 'serf/more/uuid_fields'
require 'virtus'

module Moogle
module Events

  class TargetCreated
    include Virtus
    include Aequitas
    include Serf::Message
    include Serf::More::UuidFields

    attribute :target, Object

    validates_presence_of :target
  end

end
end
