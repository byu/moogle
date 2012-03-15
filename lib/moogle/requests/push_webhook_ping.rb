require 'addressable/uri'
require 'aequitas'
require 'serf/message'
require 'serf/more/uuid_fields'
require 'virtus'

module Moogle
module Requests

  ##
  # A request to send a webhook post.
  class PushWebhookPing
    include Virtus
    include Aequitas
    include Serf::Message
    include Serf::More::UuidFields

    ##
    ## House Keeping fields
    ##

    attribute :target_id, Integer
    attribute :message_origin, String

    ##
    ## Set by Kind Specific Renderer
    ##

    attribute :data, String

    ##
    ## Set by Target's Options
    ##

    attribute :webhook_uri, String
    attribute :secret, String

    validates_with_method :valid_webhook_uri?

    def valid_webhook_uri?
      uri = Addressable::URI.parse webhook_uri
      return false, "webhook_uri not set" if uri.nil?
      return false, "webhook_uri must be an absolute URI" if uri.relative?
      return true
    end
  end

end
end
