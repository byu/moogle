require 'moogle/error'

module Moogle
module Commands

  class BaseCommand

    ##
    # @param [Moogle::Requests::CreateTarget] the creation request.
    #
    def initialize(request, *args)
      @request = request
      @args = args

      # We must first verify that the request is valid.
      unless @request.valid?
        raise ArgumentError, @request.errors.full_messages.join('. ')
      end
    rescue => e
      e.extend Moogle::Error
      raise e
    end

    def call
      raise NotImplementedError
    end

    def self.call(request, *args)
      self.new(request, *args).call
    end

    protected

    def extract_options!
      @args.last.is_a?(::Hash) ? pop : {}
    end

  end

end
end
