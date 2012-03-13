require 'active_support/core_ext/object/blank'
require 'addressable/uri'
require 'moogle/models/target'

module Moogle

  class BlogTarget < Target

    validates_with_method :options, method: :validate_options

    def validate_options
      uri = Addressable::URI.parse options['rpc_uri']
      return false, 'options rpc_uri not set' if uri.nil?
      return false, 'options rpc_uri must be absolute URI' if uri.relative?

      uri = Addressable::URI.parse options['blog_uri']
      return false, 'options blog_uri not set' if uri.nil?
      return false, 'options blog_uri must be absolute URI' if uri.relative?

      return false, 'options blog_id is blank' if options['blog_id'].blank?
      return false, 'options username is blank' if options['username'].blank?
      return false, 'options password is blank' if options['password'].blank?
      return false, 'options publish_immediately is blank' if(
        options['publish_immediately'].blank?)
      return true
    end
  end

end
