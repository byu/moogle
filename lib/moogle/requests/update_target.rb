require 'aequitas'
require 'serf/message'
require 'virtus'

require 'moogle/util/uuid_fields'

module Moogle
module Requests

  class UpdateTarget
    include Virtus
    include Aequitas
    include Serf::Message
    include Moogle::Util::UuidFields

    attribute :target_id, String
    attribute :options, Hash, default: lambda { |obj,attr| Hash.new }

    validates_presence_of :target_id
  end

end
end
