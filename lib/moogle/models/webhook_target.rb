require 'addressable/uri'
require 'moogle/models/target'

module Moogle

  class WebhookTarget < Target

    validates_with_method :options, method: :validate_options

    def validate_options
      uri = Addressable::URI.parse options['webhook_uri']
      return false, 'options webhook_uri not set' if uri.nil?
      return false, 'options webhook_uri must be absolute URI' if uri.relative?
      return true
    end
  end

end
