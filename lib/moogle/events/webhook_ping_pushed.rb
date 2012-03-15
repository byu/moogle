require 'aequitas'
require 'serf/message'
require 'virtus'

require 'moogle/util/uuid_fields'

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
    include Moogle::Util::UuidFields

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
  end

end
end
