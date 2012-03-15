require 'serf/util/uuidable'

module Moogle
module Util

  ##
  # Assumes that Virtus has already been included in the class that
  # also includes UuidFields.
  #
  module UuidFields
    extend Serf::Util::Uuidable

    def self.included(base)
      base.attribute :uuid, String, default: lambda { |o,a| create_coded_uuid }
      base.attribute :parent_uuid, String
      base.attribute :origin_uuid, String
    end
  end

end
end
