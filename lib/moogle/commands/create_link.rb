require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/messages/events/link_created'
require 'moogle/messages/requests/create_link'
require 'moogle/models'
require 'moogle/representers/link_representer'

module Moogle
module Commands

  class CreateLink < Moogle::Commands::BaseCommand

    def call
      link_model = @options[:link_model] || Moogle::Link
      target_model = @options[:target_model] || Moogle::Target
      event_class = @options[:event_class] || Moogle::Events::LinkCreated
      representer = @options[:representer] || Moogle::LinkRepresenter

      target = target_model.get @request.target_id

      unless target
        raise '404 Not found target'
      end

      link = link_model.create(
        target: target,
        receiver_ref: @request.receiver_ref,
        message_kind: @request.message_kind,
        render_options: @request.render_options)
      raise link.errors.full_messages.join('. ') unless link.saved?

      link_rep = link.dup.extend representer
      event = event_class.new(
        request_uuid: @request.uuid,
        link: link_rep)
      return event
    rescue => e
      e.extend Moogle::Error
      raise e
    end

    protected

    def request_parser
      @options[:request_parser] || Moogle::Requests::CreateLink
    end

  end

end
end
