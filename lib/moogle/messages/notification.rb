require 'aequitas'
require 'serf/message'
require 'virtus'

require 'moogle/util/uuid_fields'

module Moogle
module Messages

  class Notification
    include Virtus
    include Aequitas
    include Serf::Message
    include Moogle::Util::UuidFields

    # Targets
    attribute :receiver_refs, Array[String], default: []
    attribute :message_kind, String

    # Email
    attribute :subject, String
    attribute :text_body, String
    attribute :html_body, String
    attribute :html_content_type, String, default: 'text/html; charset=UTF-8'
    attribute :categories, Array[String], default: []

    # Tweet
    attribute :short_body, String

    # Webhook
    attribute :data, String
  end

end
end
