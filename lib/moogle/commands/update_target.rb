require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/models'
require 'moogle/messages/events/target_updated'

module Moogle
module Commands

  class UpdateTarget < Moogle::Commands::BaseCommand

    def call
      target_model = @options[:target_model] || Moogle::Target
      event_class = @options[:event_class] || Moogle::Events::TargetUpdated
      representer = @options[:representer] || Moogle::TargetRepresenter

      target = target_model.get @request.target_id
      raise '404 Not found' unless target

      result = target.update update_params
      raise target.errors.full_messages.join('; ') unless target.saved?

      target_rep = target.dup.extend representer
      return event_class.new(
        request_uuid: @request.uuid,
        target: target)
    rescue => e
      e.extend Moogle::Error
      raise e
    end

    protected

    def update_params
      { options: @request.options }
    end

  end

end
end
