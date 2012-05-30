require 'addressable/uri'
require 'hashie'
require 'serf/command'
require 'serf/util/uuidable'
require 'xmlrpc/client'

require 'moogle/error'

module Moogle
module Commands

  ##
  # Posts an entry to a target blog.
  #
  class PushBlogEntry
    include Serf::Command

    def initialize(*args)
      extract_options! args
    end

    def call(request, context=nil)
      uri = Addressable::URI.parse request.rpc_uri
      request.host = uri.host
      request.path = uri.path
      request.port = uri.port

      # Xml-Rpc server
      server = XMLRPC::Client.new request.host, request.path, request.port

      # Makes the metaWeblog new post API call
      post_params = [
        'metaWeblog.newPost',
        request.blog_id,
        request.username,
        request.password,
        {
          'title' => request.subject,
          'link' => request.blog_uri,
          'description' => request.html_body,
          'categories' => request.categories
        },
        request.publish_immediately
      ]
      post_ref = server.call *post_params

      # Return an event representing this action.
      event = Hashie::Mash.new(
        kind: 'moogle/events/blog_entry_pushed',
        message_origin: request.message_origin,
        target_id: request.target_id,
        post_ref: post_ref)
      Serf::Util::Uuidable.annotate_with_uuids! event, request
      return event
    rescue XMLRPC::FaultException => e
      e.extend Moogle::Error
      raise e
    rescue => e
      e.extend Moogle::Error
      raise e
    end
  end

end
end
