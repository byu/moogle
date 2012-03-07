require 'serf/command'
require 'xmlrpc/client'

require 'moogle/error'
require 'moogle/events/blog_entry_pushed'
require 'moogle/requests/push_blog_entry'

module Moogle
module Commands

  ##
  # Posts an entry to a target blog.
  #
  class PushBlogEntry
    include Serf::Command

    self.request_parser = Moogle::Requests::PushBlogEntry

    def call
      # Xml-Rpc server
      server = XMLRPC::Client.new request.host, request.path, request.port

      # Makes the metaWeblog new post API call
      post_ref = server.call(
        'metaWeblog.newPost',
        request.blog_id,
        request.username,
        request.password,
        {
          'title' => request.title,
          'link' => request.blog_uri,
          'description' => request.description,
          'categories' => request.categories
        },
        request.publish_immediately)

      # Return an event representing this action.
      event_class = opts :event_class, Moogle::Events::BlogEntryPushed
      return event_class.new(
        request_uuid: request.uuid,
        message_origin: request.message_origin,
        target_id: request.target_id,
        post_ref: post_ref)
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
