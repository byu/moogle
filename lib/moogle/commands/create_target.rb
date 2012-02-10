require 'active_support/core_ext/string/inflections'

require 'moogle/commands/base_command'
require 'moogle/error'
require 'moogle/models'

module Moogle
module Commands

  class CreateTarget < Moogle::Commands::BaseCommand

    ##
    # @return [Moogle::Target] the created target, properly subclassed by type.
    #
    def call
      # We must first verify that the request is valid.
      unless @request.valid?
        raise ArgumentError, @request.errors.full_messages.join('. ')
      end

      # Determine our model class name, and get the constant.
      model_name = "moogle/#{@request.type}_target".classify
      target_model = model_name.constantize rescue Moogle::Target

      # Now, create the target, and raise on errors.
      result = target_model.create(
        owner_ref:  @request.owner_ref,
        options: @request.options)
      raise result.errors.full_messages.join('. ') unless result.saved?

      return result
    rescue => e
      e.extend Moogle::Error
      raise e
    end

  end

end
end
