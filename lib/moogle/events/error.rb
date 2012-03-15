require 'aequitas'
require 'serf/message'
require 'virtus'

require 'moogle/util/uuid_fields'

module Moogle
module Events

  class Error
    include Virtus
    include Aequitas
    include Serf::Message
    include Moogle::Util::UuidFields

    attribute :error, String
    attribute :message, String
    attribute :backtrace, String
    attribute :context, Object

    validates_presence_of :error, :message, :context
  end

end
end
