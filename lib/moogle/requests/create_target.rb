require 'aequitas'
require 'serf/message'
require 'serf/more/uuid_fields'
require 'virtus'

module Moogle
module Requests

  class CreateTarget
    include Virtus
    include Aequitas
    include Serf::Message
    include Serf::More::UuidFields

    attribute :type, String
    attribute :owner_ref, String
    attribute :options, Hash, default: lambda { |obj,attr| Hash.new }

    validates_with_method :type, method: :has_valid_type?
    validates_presence_of :owner_ref

    TYPES = [
      'blog',
      'email',
      'facebook',
      'twitter',
      'webhook'
    ]

    def has_valid_type?
      if TYPES.include? type
        return true, 'Valid'
      else
        return false, "'#{type}' is invalid type. Must be in #{TYPES}"
      end
    end
  end

end
end
