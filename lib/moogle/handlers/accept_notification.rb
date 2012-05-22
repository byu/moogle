require 'active_support/core_ext/object/blank'
require 'serf/command'
require 'serf/util/error_handling'

require 'moogle/models'

module Moogle
module Handlers

  ##
  # Handler that accepts Moogle::Messges::Notifications and creates
  # actual push requests to relay the notification to each found target.
  #
  class AcceptNotification
    include Serf::Command
    include Serf::Util::ErrorHandling

    attr_reader :pusher_queue
    attr_reader :default_options

    DEFAULT_PUSH_OPTIONS = {
      'from' => 'no-reply@example.com'
    }.freeze

    KIND_MAP = {
      'Moogle::BlogTarget' => 'moogle/requests/push_blog_entry',
      'Moogle::EmailTarget' => 'moogle/requests/push_email',
      'Moogle::WebhookTarget' => 'moogle/requests/push_webhook_ping'
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
          push_data = [
            Hashie::Mash.new(default_options),
            Hashie::Mash.new(target.options),
            Hashie::Mash.new(request),
            Hashie::Mash.new({
              target_id: target.id,
              message_origin: "#{request.message_kind}:#{request.uuid}:"
            })
          ].reduce(&:merge)
          pusher_queue.push filtered_attributes_for(target.type, push_data)
        end
      end

      return nil
    rescue => e
      e.extend Moogle::Error
      raise e
    end

    def filtered_attributes_for(target_type, attributes)
      filters = case target_type.to_s
      when 'Moogle::BlogTarget'
        [
          :target_id,
          :message_origin,
          :subject,
          :html_body,
          :categories,
          :rpc_uri,
          :blog_id,
          :username,
          :password,
          :blog_uri,
          :publish_immediately
        ]
      when 'Moogle::EmailTarget'
        [
          :target_id,
          :message_origin,
          :subject,
          :text_body,
          :html_body,
          :html_content_type,
          :categories,
          :to,
          :from
        ]
      when 'Moogle::WebhookTarget'
        [
          :target_id,
          :message_origin,
          :data,
          :webhook_uri,
          :secret
        ]
      else
        raise ArgumentError, "Unsupported Target #{target_type}"
      end
      new_attributes =  attributes.reject { |k| !filters.include?(k.to_sym) }
      new_attributes['kind'] = KIND_MAP[target_type.to_s]
      return new_attributes
    end
  end

end
end
