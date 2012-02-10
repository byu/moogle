require 'aequitas'
require 'serf/message'
require 'uuidtools'
require 'virtus'

module Moogle
module Requests

  class UpdateLink
    include Virtus
    include Aequitas
    include Serf::Message

    attribute :link_id, String
    attribute :render_options, Hash, :default => lambda { |obj,attr| Hash.new }

    attribute :uuid, String, :default => lambda { |obj,attr|
      UUIDTools::UUID.random_create.to_s
    }

    validates_presence_of :link_id, :uuid
  end

end
end
