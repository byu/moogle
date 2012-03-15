require 'aequitas'
require 'serf/message'
require 'virtus'

require 'moogle/util/uuid_fields'

module Moogle
module Requests

  ##
  # Request to email a message to a recipient
  #
  class PushEmail
    include Virtus
    include Aequitas
    include Serf::Message
    include Moogle::Util::UuidFields

    ##
    ## House Keeping fields
    ##

    attribute :target_id, Integer
    attribute :message_origin, String

    ##
    ## Parameters that make up the BlogEntry.
    ##

    attribute :subject, String
    attribute :text_body, String
    attribute :html_body, String
    attribute :html_content_type, String, default: 'text/html; charset=UTF-8'
    attribute :categories, Array[String], default: []

    ##
    ## Parameters used to send the email.
    ##

    attribute :to, String
    attribute :from, String

    validates_presence_of :to, :from, :subject, :text_body
  end

end
end
