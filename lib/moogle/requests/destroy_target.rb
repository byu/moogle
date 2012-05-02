require 'aequitas'
require 'serf/message'
require 'serf/more/uuid_fields'
require 'virtus'

module Moogle
module Requests

  class DestroyTarget
    include Virtus
    include Aequitas
    include Serf::Message
    include Serf::More::UuidFields

    attribute :target_id, Integer

    validates_presence_of :target_id

  end

end
end
