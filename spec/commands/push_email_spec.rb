require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Commands::PushEmail' do
  before(:each) do
    Mail.defaults do
      delivery_method :test
    end
  end

  let(:request) {{
    uuid: '85d9e997-6dcd-499e-9a5d-09dc0dc8c3b4',
    target_id: 1,
    message_origin: 'btwb/events/daily_wod_created',
    subject: 'My Test Subject',
    text_body: 'This is a text email',
    html_body: 'This is an html body email',
    categories: ['tag1'],
    to: 'user@example.com',
    from: 'from_user@example.com'
  }}
  let(:command) {
    Moogle::Commands::PushEmail
  }
  let(:options) {{
  }}

  it 'should push an email' do
    result = command.call request, options
    result.kind.should == 'moogle/events/email_pushed'

    result.target_id.should == request[:target_id]
    result.message_origin == request[:message_origin]
    result.request_uuid.should == request[:uuid]
    result.request.should_not be_nil

    deliveries = Mail.delivery_method.class.deliveries
    deliveries.size.should == 1
    sent_mail = deliveries.first
    sent_mail.to.should == [request[:to]]
    sent_mail.from.should == [request[:from]]
    sent_mail.subject.should == request[:subject]
  end

end
