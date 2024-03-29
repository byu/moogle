require 'addressable/uri'
require 'aequitas'
require 'serf/message'
require 'serf/more/uuid_fields'
require 'virtus'

module Moogle
module Requests

  ##
  # A request to create a blog entry at a target blog supporting
  # the 'metaWeblog.newPost' api.
  class PushBlogEntry
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
    ## Parameters that make up the BlogEntry.
    ##

    attribute :subject, String
    attribute :html_body, String
    attribute :categories, Array[String], default: []

    ##
    ## Parameters used to post the BlogEntry.
    ##

    # XML-RPC server rpc_uri.
    # http://my_block.wordpress.com/xmlrpc.php'
    attribute :rpc_uri, String
    attribute :blog_id, String
    # The username password authentication
    attribute :username, String
    attribute :password, String
    # Display URI
    attribute :blog_uri, String
    # Publish Immediately
    attribute :publish_immediately, Boolean

    def host
      uri = Addressable::URI.parse rpc_uri
      return uri.host
    end

    def path
      uri = Addressable::URI.parse rpc_uri
      return uri.path
    end

    def port
      uri = Addressable::URI.parse rpc_uri
      return uri.port
    end
  end

end
end
