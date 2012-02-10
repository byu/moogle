require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/models'

module Moogle
module Commands

  class UpdateTarget < Moogle::Commands::BaseCommand

    def call
      target_id = @request.target_id

      options = extract_options!
      target_model = options[:target_model] || Moogle::Target

      target = target_model.get target_id
      raise '404 Not found' unless target

      result = target.update options: @request.options
      raise target.errors.full_messages.join('; ') unless target.saved?
      return target
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
