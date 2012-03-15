require 'mail'
require 'serf/command'

require 'moogle/events/email_pushed'
require 'moogle/requests/push_email'

module Moogle
module Commands

  ##
  # Sends an email
  #
  class PushEmail
    include Serf::Command

    self.request_factory = Moogle::Requests::PushEmail

    def call
      mail_class = opts :mail_class, Mail

      # Create the mail object to send, get a local var 'req' so it is
      # visible inside the proc.
      req = request
      mail = mail_class.new do
        to req.to
        from req.from
        subject req.subject

        text_part do
          body req.text_body
        end

        if req.html_body
          html_part do
            content_type req.html_content_type
            body req.html_body
          end
        end
      end

      # Tags for postmark
      if mail.respond_to?(:tag=) && !request.categories.blank?
        mail.tag = request.categories.sort.join ', '
      end

      # Deliver the mail using the default mailer delivery settings
      mail.deliver!

      # Return an event representing this action.
      event_class = opts :event_class, Moogle::Events::EmailPushed
      return event_class.new(
        request.create_child_uuids.merge(
          message_origin: request.message_origin,
          target_id: request.target_id,
          request: request))
    end
  end

end
end
