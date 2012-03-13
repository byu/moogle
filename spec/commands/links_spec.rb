require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Commands::CreateLink' do
  let(:existing_target) {
    Moogle::WebhookTarget.create(
      owner_ref: 'System:1a',
      options: {
        'webhook_uri' => 'http://example.com/target'
      })
  }
  let(:request_hash) {{
    target_id: existing_target.id,
    receiver_ref: 'Gym:1',
    message_kind: 'my_message_kind'
  }}
  let(:request) {
    Moogle::Requests::CreateLink.new request_hash
  }
  let(:command) {
    Moogle::Commands::CreateLink
  }

  it 'should create a link' do
    result = command.call request
    result.kind.should == 'moogle/events/link_created'
    result.request_uuid.should == request.uuid
    result.link.message_kind.should == 'my_message_kind'
    result.link.receiver_ref.should == 'Gym:1'
  end

  it 'should be able to parse a hash as request' do
    result = command.call request
    result.kind.should == 'moogle/events/link_created'
    result.link.message_kind.should == 'my_message_kind'
    result.link.receiver_ref.should == 'Gym:1'
  end
end

describe 'Moogle::Commands::DestroyLink' do
  let(:request_hash) {{
    link_id: 12345
  }}
  let(:command) {
    Moogle::Commands::DestroyLink
  }

  describe 'with non-existent link' do
    let(:request) {
      Moogle::Requests::DestroyLink.new request_hash
    }

    it 'should succeed' do
      result = command.call request
      result.kind.should == 'moogle/events/link_destroyed'
      result.link_id.should == 12345
      result.request_uuid.should == request.uuid
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
        Moogle::Requests::CreateLink.new(
          target_id: existing_target.id,
          receiver_ref: 'Gym:1',
          message_kind: 'my_message_kind')).link
    }
    let(:request) {
      Moogle::Requests::DestroyLink.new link_id: existing_link.id
    }

    it 'should succeed' do
      result = command.call request
      result.kind.should == 'moogle/events/link_destroyed'
      result.link_id.should == existing_link.id
      result.request_uuid.should == request.uuid
    end
  end

  it 'should be able to parse a hash as request' do
    result = command.call request_hash
    result.kind.should == 'moogle/events/link_destroyed'
    result.link_id.should == 12345
  end
end
