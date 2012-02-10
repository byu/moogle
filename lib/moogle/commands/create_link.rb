require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/models'

module Moogle
module Commands

  class CreateLink < Moogle::Commands::BaseCommand

    def call
      options = extract_options!
      link_model = options[:link_model] || Moogle::Link
      target_model = options[:target_model] || Moogle::Target

      target = target_model.get @request.target_id

      unless target
        raise '404 Not found target'
      end

      result = link_model.create(
        target: target,
        receiver_ref: @request.receiver_ref,
        message_kind: @request.message_kind,
        render_options: @request.render_options)
      raise result.errors.full_messages.join('. ') unless result.saved?

      return result
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
