require 'roar'

module Moogle

  module LinkRepresenter
    include Roar::Representer::JSON

    property :kind
    property :id

    def kind
      'moogle/domain/link'
    end

  end

end
