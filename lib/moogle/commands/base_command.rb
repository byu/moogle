require 'moogle/error'

module Moogle
module Commands

  class BaseCommand

    ##
    # @param [Moogle::Requests::CreateTarget] the creation request.
    #
    def initialize(request, *args)
      @args = args
      @options = @args.last.is_a?(::Hash) ? pop : {}

      @request = request.is_a?(Hash) ? request_parser.parse(request) : request

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

    def request_parser
      raise ArgumentError, 'Parsing Hash request is Not Supported'
    end

  end

end
end
