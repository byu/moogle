require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Commands::CreateLink' do
  let(:existing_target) {
    Moogle::WebhookTarget.create(
      owner_ref: 'System:1a',
      options: {
        'webhook_uri' => 'http://example.com/target'
      })
  }
  let(:request) {
    Hashie::Mash.new(
      target_id: existing_target.id,
      receiver_ref: 'Gym:1',
      message_kind: 'my_message_kind',
      uuid: 'abc_uuid')
  }
  let(:command) {
    Moogle::Commands::CreateLink
  }

  it 'should create a link' do
    result = command.call nil, request
    result.kind.should == 'moogle/events/link_created'
    result.parent_uuid.should == request[:uuid]
    result.link.message_kind.should == 'my_message_kind'
    result.link.receiver_ref.should == 'Gym:1'
  end
end

describe 'Moogle::Commands::DestroyLink' do
  let(:request) {
    Hashie::Mash.new(
      link_id: 12345,
      uuid: 'abc_uuid')
  }
  let(:command) {
    Moogle::Commands::DestroyLink
  }

  describe 'with non-existent link' do

    it 'should succeed' do
      result = command.call nil, request
      result.kind.should == 'moogle/events/link_destroyed'
      result.link_id.should == 12345
      result.parent_uuid.should == request[:uuid]
    end
  end

  describe 'with existing link' do
    let(:existing_target) {
      Moogle::WebhookTarget.create(
        owner_ref: 'System:1a',
        options: {
          'webhook_uri' => 'http://example.com/target'
        })
    }
    let(:existing_link) {
      Moogle::Commands::CreateLink.call(
        nil,
        Hashie::Mash.new(
          target_id: existing_target.id,
          receiver_ref: 'Gym:1',
          message_kind: 'my_message_kind'
        ))['link']
    }
    let(:request) {
      Hashie::Mash.new(
        link_id: existing_link.id,
        uuid: 'abc_uuid')
    }

    it 'should succeed' do
      result = command.call nil, request
      result.kind.should == 'moogle/events/link_destroyed'
      result.link_id.should == existing_link.id
      result.parent_uuid.should == request[:uuid]
    end
  end
end
