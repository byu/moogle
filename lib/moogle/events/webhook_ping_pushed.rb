require 'aequitas'
require 'serf/message'
require 'uuidtools'
require 'virtus'

module Moogle
module Events

  ##
  # Signals that a we made a webhook callback for a target_id, with the
  # a reference to a message's origin.
  #
  class WebhookPingPushed
    include Virtus
    include Aequitas
    include Serf::Message

    ##
    # The target_id of the webhook recipient
    attribute :target_id, Integer

    ##
    # A descriptive origin that describes how we can find more about
    # what was posted. And why.
    attribute :message_origin, String

    ##
    # The uri where we posted the callback
    attribute :webhook_uri, String

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
