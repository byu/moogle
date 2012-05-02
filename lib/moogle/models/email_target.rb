require 'moogle/models/target'

module Moogle

  class EmailTarget < Moogle::Target

    validates_with_method :options, method: :validate_options

    def validate_options
      return false, 'options "to" is blank' if options['to'].blank?
      true
    end
  end

end
