require 'roar'

module Moogle

  module TargetRepresenter
    include Roar::Representer::JSON

    property :kind
    property :id

    def kind
      'moogle/domain/target'
    end

  end

end
