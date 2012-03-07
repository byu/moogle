require 'aequitas'
require 'serf/message'
require 'uuidtools'
require 'virtus'

module Moogle
module Requests

  class CreateTarget
    include Virtus
    include Aequitas
    include Serf::Message

    attribute :type, String
    attribute :owner_ref, String
    attribute :options, Hash, default: lambda { |obj,attr| Hash.new }

    attribute :uuid, String, default: lambda { |obj,attr|
      UUIDTools::UUID.random_create.to_s
    }

    validates_with_method :type, method: :has_valid_type?
    validates_presence_of :owner_ref, :uuid

    TYPES = [
      'email',
      'facebook',
      'twitter',
      'webhook',
      'wordpress'
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
