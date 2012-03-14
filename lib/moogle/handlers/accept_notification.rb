require 'active_support/core_ext/object/blank'
require 'serf/command'
require 'serf/util/error_handling'

require 'moogle/events/error'
require 'moogle/messages/notification'
require 'moogle/models'
require 'moogle/requests/push_blog_entry'
require 'moogle/requests/push_email'
require 'moogle/requests/push_facebook_action'
require 'moogle/requests/push_tweet'
require 'moogle/requests/push_webhook_ping'

module Moogle
module Handlers

  ##
  # Handler that accepts Moogle::Messges::Notifications and creates
  # actual push requests to relay the notification to each found target.
  #
  class AcceptNotification
    include Serf::Command
    include Serf::Util::ErrorHandling

    self.request_factory = Moogle::Messages::Notification

    attr_reader :pusher_queue
    attr_reader :default_options

    DEFAULT_PUSH_OPTIONS = {
      'from' => 'no-reply@example.com'
    }.freeze

    def initialize
      @pusher_queue = opts! :pusher_queue
      @default_options = opts :default_push_options, DEFAULT_PUSH_OPTIONS
    end

    def call
      return nil if request.receiver_refs.blank? || request.message_kind.blank?

      # Get all targets whose links' kinds + receivers match.
      model = opts :model, Moogle::Target
      targets = model.all(
        model.links.message_kind => request.message_kind,
        model.links.receiver_ref => request.receiver_refs)

      # Create a new push request for each target found.
      # Push each request to the pusher queue, and errors are caught
      # and pushed to the error channel.
      targets.each do |target|
        with_error_handling(
            kind: 'moogle/handlers/accept_notification',
            request: request.to_hash,
            target_id: target.id) do
          request_factory = request_factory_for target.type
          push_data = [
            request.attributes,
            default_options,
            target.options
          ].reduce(&:merge)
          push_request = request_factory.build push_data
          pusher_queue.push push_request.to_hash
        end
      end

      return nil
    rescue => e
      e.extend Moogle::Error
      raise e
    end

    def request_factory_for(target_type)
      case target_type.to_s
      when 'Moogle::BlogTarget'
        Moogle::Requests::PushBlogEntry
      when 'Moogle::EmailTarget'
        Moogle::Requests::PushEmail
      when 'Moogle::FacebookTarget'
        Moogle::Requests::PushFacebookAction
      when 'Moogle::TwitterTarget'
        Moogle::Requests::PushTweet
      when 'Moogle::WebhookTarget'
        Moogle::Requests::PushWebhookPing
      else
        raise ArgumentError, "Unsupported Target #{target_type}"
      end
    end
  end

end
end
