require 'data_mapper'

module Moogle

  class Target
    include DataMapper::Resource

    def self.default_repository_name
      :moogle_db
    end

    property :id, Serial
    property :type, Discriminator
    property :owner_ref, String, length: 255
    property :options, Json, default: {}
    timestamps :at

    has n, :links
    has n, :post_logs
  end

end
