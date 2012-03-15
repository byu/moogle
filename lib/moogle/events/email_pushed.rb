require 'aequitas'
require 'serf/message'
require 'virtus'

require 'moogle/requests/push_email'
require 'moogle/util/uuid_fields'

module Moogle
module Events

  ##
  # Signals that a blog entry was posted for a target_id, with the
  # a reference to a message's origin.
  #
  class EmailPushed
    include Virtus
    include Aequitas
    include Serf::Message
    include Moogle::Util::UuidFields

    ##
    # The target_id of the email recipient
    attribute :target_id, Integer

    ##
    # A descriptive origin that describes how we can find more about
    # what was posted. And why.
    attribute :message_origin, String

    ##
    # The returned post reference id of the blog entry created.
    attribute :request, Moogle::Requests::PushEmail
  end

end
end
