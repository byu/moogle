require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Handlers::AcceptNotification' do
  let(:target) {
    Moogle::EmailTarget.create(
      owner_ref: 'member:1',
      options: {
        'to' => 'target@example.com',
        'from' => 'source@example.com'
      },
      links: [
        {
          receiver_ref: 'member:1',
          message_kind: 'some_application/my_notification'
        }
      ]
    )
  }

  before(:each) do
    target
  end
  after(:each) do
    target.destroy
  end

  let(:message) {{
    message_kind: 'some_application/my_notification',
    receiver_refs: ['member:1', 'gym:1'],
    subject: 'Subject',
    html_body: 'My Html Body',
    text_body: 'Text Body'
  }}
  let(:handler) {
    Moogle::Handlers::AcceptNotification
  }

  it 'should accept a notification' do
    pusher_queue = []
    error_channel = []
    results = handler.call(
      message,
      pusher_queue: pusher_queue,
      error_channel: error_channel)
    results.should be_nil
    pusher_queue.first.kind_of?(Hash).should be_true
    pusher_queue.first[:subject].should == 'Subject'
    pusher_queue.first[:html_body].should == 'My Html Body'
    pusher_queue.first[:text_body].should == 'Text Body'
    pusher_queue.first[:to].should == 'target@example.com'
    pusher_queue.first[:from].should == 'source@example.com'
    error_channel.should == []
  end

end
