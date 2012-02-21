require 'active_support/core_ext/string/inflections'
require 'roar/representer/json'

require 'moogle/representers/link_representer'

module Moogle

  module TargetRepresenter
    include Roar::Representer::JSON

    property :kind
    property :id
    property :translated_type, :from => :type
    property :owner_ref
    property :options
    property :created_at
    property :updated_at

    collection(
      :links,
      :extend => Moogle::LinkRepresenter)

    def kind
      'moogle/domain/target'
    end

    def translated_type
      return $1.to_s.tableize if /^Moogle::(.+)Target$/ === self.type.to_s
      return nil
    end

  end

end
