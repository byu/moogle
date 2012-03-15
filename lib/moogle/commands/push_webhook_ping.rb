require 'addressable/uri'
require 'faraday'
require 'rafaday/body_signing_middleware'
require 'serf/command'

require 'moogle/events/webhook_ping_pushed'
require 'moogle/requests/push_webhook_ping'

module Moogle
module Commands

  ##
  # Posts a webhook callback.
  #
  class PushWebhookPing
    include Serf::Command

    self.request_factory = Moogle::Requests::PushWebhookPing

    def call
      # Options pulled from the delegated object
      ssl_opt = opts :ssl_opt

      webhook_uri = Addressable::URI.parse request.webhook_uri
      secret = request.secret

      # Build request and make it.
      conn = Faraday.new url: webhook_uri.origin, ssl: ssl_opt do |b|
        # Signs the post body, adds 'sig' to query parameters.
        b.use Rafaday::BodySigningMiddleware, secret: secret if secret

        b.response :raise_error
        b.adapter  :net_http
      end
      results = conn.post webhook_uri.path, request.data

      # Checks for errors that didn't get caught in the response :raise_error.
      case results.status
      when 200..299
      else
        raise "PushWebhookPing (#{request.uuid}) failed: #{results.status}"
      end

      event_class = opts :event_class, Moogle::Events::WebhookPingPushed
      return event_class.new(
        parent_uuid: request.uuid,
        message_origin: request.message_origin,
        target_id: request.target_id,
        webhook_uri: request.webhook_uri)
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
