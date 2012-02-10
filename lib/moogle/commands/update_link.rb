require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/models'

module Moogle
module Commands

  class UpdateLink < Moogle::Commands::BaseCommand

    def call
      options = extract_options!
      link_model = options[:link_model] || Moogle::Link

      link_id = @request.link_id
      link = link_model.get link_id
      raise '404 Not found' unless link

      link.update update_params
      raise link.errors.full_messages.join('; ') unless link.saved?

      return link
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
