require 'aequitas'
require 'serf/message'
require 'uuidtools'
require 'virtus'

module Moogle
module Events

  ##
  # Signals that a blog entry was posted for a target_id, with the
  # a reference to a message's origin.
  #
  class BlogEntryPushed
    include Virtus
    include Aequitas
    include Serf::Message

    ##
    # The target_id of the blog where we posted.
    attribute :target_id, Integer

    ##
    # A descriptive origin that describes how we can find more about
    # what was posted. And why.
    attribute :message_origin, String

    ##
    # The returned post reference id of the blog entry created.
    attribute :post_ref, String

    ##
    # The uuid of the request.
    attribute :request_uuid, String

    ##
    # This event's uuid.
    attribute :uuid, String, default: lambda { |obj,attr|
      UUIDTools::UUID.random_create.to_s
    }
  end

end
end
