require 'roar/representer/json'

module Moogle

  module LinkRepresenter
    include Roar::Representer::JSON

    property :kind
    property :id
    property :receiver_ref
    property :message_kind
    property :render_options
    property :suspended
    property :created_at
    property :updated_at

    def kind
      'moogle/domain/link'
    end

  end

end
