require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/models'

module Moogle
module Commands

  class DestroyLink < Moogle::Commands::BaseCommand

    def call
      link_id = @request.link_id
      options = extract_options!
      link_model = options[:link_model] || Moogle::Link
      link = link_model.get link_id
      return link ? link.destroy : true
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
