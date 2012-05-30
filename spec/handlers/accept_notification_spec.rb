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

  let(:message) {
    Hashie::Mash.new(
      message_kind: 'some_application/my_notification',
      receiver_refs: ['member:1', 'gym:1'],
      subject: 'Subject',
      html_body: 'My Html Body',
      text_body: 'Text Body')
  }
  let(:handler) {
    Moogle::Handlers::AcceptNotification
  }

  it 'should accept a notification' do
    pusher_queue = Queue.new
    error_channel = Queue.new
    results = handler.call(
      message,
      {},
      pusher_queue: pusher_queue,
      error_channel: error_channel)
    results.should be_nil
    pusher_queue.size.should == 1
    item = pusher_queue.pop
    item[:message][:subject].should == 'Subject'
    item[:message][:html_body].should == 'My Html Body'
    item[:message][:text_body].should == 'Text Body'
    item[:message][:to].should == 'target@example.com'
    item[:message][:from].should == 'source@example.com'
    error_channel.should be_empty
  end

end
