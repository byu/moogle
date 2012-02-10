require 'data_mapper'

module Moogle

  class Link
    include DataMapper::Resource

    property :id, Serial
    property :receiver_ref, String, length: 255
    property :message_kind, String, length: 255
    property :render_options, Json
    property :suspended, Boolean, :default => false
    timestamps :at

    belongs_to :target
  end

end
