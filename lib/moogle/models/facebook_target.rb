require 'moogle/models/target'

module Moogle

  class FacebookTarget < Target

    validates_with_method :options, method: :validate_options

    def validate_options
      true
    end
  end

end
