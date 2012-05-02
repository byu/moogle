require 'aequitas'
require 'serf/message'
require 'serf/more/uuid_fields'
require 'virtus'

module Moogle
module Events

  class Error
    include Virtus
    include Aequitas
    include Serf::Message
    include Serf::More::UuidFields

    attribute :error, String
    attribute :message, String
    attribute :backtrace, String
    attribute :context, Object

    validates_presence_of :error, :message, :context
  end

end
end
