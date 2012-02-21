require 'aequitas'
require 'serf/message'
require 'uuidtools'
require 'virtus'

module Moogle
module Requests

  class FindTargets
    include Virtus
    include Aequitas
    include Serf::Message

    attribute :owner_ref, String

    validates_presence_of :owner_ref
  end

end
end
