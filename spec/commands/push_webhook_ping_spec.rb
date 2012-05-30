require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Commands::PushWebhookPing' do
  let(:request) {
    Hashie::Mash.new(
      uuid: '85d9e997-6dcd-499e-9a5d-09dc0dc8c3b4',
      target_id: 1,
      message_origin: 'btwb/events/daily_wod_created',
      data: '{}',
      webhook_uri: 'http://www.example.com/',
      secret: 'secretpassword')
  }
  let(:command) {
    Moogle::Commands::PushWebhookPing
  }

  it 'should push a ping' do
    VCR.use_cassette('push_webhook_ping') do
      result = command.call request
      result.kind.should == 'moogle/events/webhook_ping_pushed'

      result.webhook_uri.should == request[:webhook_uri]
      result.target_id.should == request[:target_id]
      result.message_origin.should == request[:message_origin]
      result.parent_uuid.should == request[:uuid]
    end
  end

end
