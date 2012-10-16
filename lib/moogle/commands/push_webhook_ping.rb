require 'addressable/uri'
require 'faraday'
require 'hashie'
require 'serf/command'
require 'serf/util/uuidable'

module Moogle
module Commands

  ##
  # Posts a webhook callback.
  #
  class PushWebhookPing
    include Serf::Command

    def initialize(*args)
      extract_options! args
    end

    def call(headers, request)
      # Options pulled from the delegated object
      ssl_opt = opts :ssl_opt

      webhook_uri = Addressable::URI.parse request.webhook_uri

      # Build request and make it.
      conn = Faraday.new url: webhook_uri.origin, ssl: ssl_opt do |b|
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

      # Return an event representing this action.
      event = Hashie::Mash.new(
        kind: 'moogle/events/webhook_ping_pushed',
        message_origin: request.message_origin,
        target_id: request.target_id,
        webhook_uri: request.webhook_uri)
      Serf::Util::Uuidable.annotate_with_uuids! event, request
      return event
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
