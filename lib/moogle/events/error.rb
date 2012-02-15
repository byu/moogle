require 'aequitas'
require 'serf/message'
require 'uuidtools'
require 'virtus'

module Moogle
module Events

  class Error
    include Virtus
    include Aequitas
    include Serf::Message

    attribute :error_class, String
    attribute :message, String
    attribute :backtrace, String
    attribute :request, Object
    attribute :uuid, String, :default => lambda { |obj,attr|
      UUIDTools::UUID.random_create.to_s
    }

    validates_presence_of :error_class, :message, :request, :uuid

  end

end
end
