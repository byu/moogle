require 'data_mapper'

module Moogle

  class PostLog
    include DataMapper::Resource

    def self.default_repository_name
      :moogle_db
    end

    property :id, Serial
    property :message_kind, String, length: 255
    property :message_ref, String, length: 255
    property :post_ref, String, length: 255
    timestamps :at

    belongs_to :target
  end

end
