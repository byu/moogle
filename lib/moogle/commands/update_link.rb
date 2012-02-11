require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/models'
require 'moogle/messages/events/link_updated'

module Moogle
module Commands

  class UpdateLink < Moogle::Commands::BaseCommand

    def call
      link_model = @options[:link_model] || Moogle::Link
      event_class = @options[:event_class] || Moogle::Events::LinkUpdated
      representer = @options[:representer] || Moogle::LinkRepresenter

      link = link_model.get @request.link_id
      raise '404 Not found' unless link

      link.update update_params
      raise link.errors.full_messages.join('; ') unless link.saved?

      link_rep = link.dup.extend representer
      return event_class.new(
        request_uuid: @request.uuid,
        link: link)
    rescue => e
      e.extend Moogle::Error
      raise e
    end

    protected

    def update_params
      { render_options: @request.render_options }
    end

  end

end
end
