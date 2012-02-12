require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Commands::CreateLink' do
  let(:existing_target) {
    Moogle::Commands::CreateTarget.call(
      Moogle::Requests::CreateTarget.new(
        type: :webhook,
        owner_ref: 'System:1a')).target
  }
  let(:request_hash) {{
    target_id: existing_target.id,
    receiver_ref: 'Gym:1',
    message_kind: 'my_message_kind',
    render_options: { 'parameter' => 'value'}
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
    result.link.render_options.should == { 'parameter' => 'value' }
    result.link.suspended.should == false
  end

  it 'should be able to parse a hash as request' do
    result = command.call request
    result.kind.should == 'moogle/events/link_created'
    result.link.message_kind.should == 'my_message_kind'
    result.link.receiver_ref.should == 'Gym:1'
    result.link.render_options.should == { 'parameter' => 'value' }
    result.link.suspended.should == false
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
      Moogle::Commands::CreateTarget.call(
        Moogle::Requests::CreateTarget.new(
          type: :wordpress,
          owner_ref: 'System:1')).target
    }
    let(:existing_link) {
      Moogle::Commands::CreateLink.call(
        Moogle::Requests::CreateLink.new(
          target_id: existing_target.id,
          receiver_ref: 'Gym:1',
          message_kind: 'my_message_kind',
          render_options: { 'parameter' => 'value'})).link
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

describe 'Moogle::Commands::UpdateLink' do
  let(:existing_target) {
    Moogle::Commands::CreateTarget.call(
      Moogle::Requests::CreateTarget.new(
        type: :wordpress,
        owner_ref: 'System:1')).target
  }
  let(:existing_link) {
    Moogle::Commands::CreateLink.call(
      Moogle::Requests::CreateLink.new(
        target_id: existing_target.id,
        receiver_ref: 'Gym:1',
        message_kind: 'my_message_kind',
        render_options: { 'nada_parameter' => 'some_value'})).link
  }
  let(:request_hash) {{
    link_id: existing_link.id,
    render_options: {
      parameter1: 'value1'
    }
  }}
  let(:request) {
    Moogle::Requests::UpdateLink.new request_hash
  }
  let(:command) {
    Moogle::Commands::UpdateLink
  }

  it 'should update existing link' do
    result = command.call request
    result.kind.should == 'moogle/events/link_updated'
    result.link.render_options.should == { parameter1: 'value1' }
    result.request_uuid.should == request.uuid
  end

  it 'should be able to parse a hash as request' do
    result = command.call request
    result.kind.should == 'moogle/events/link_updated'
    result.link.render_options.should == { parameter1: 'value1' }
  end
end

describe 'Moogle::Commands::SuspendLink' do
  let(:existing_target) {
    Moogle::Commands::CreateTarget.call(
      Moogle::Requests::CreateTarget.new(
        type: :wordpress,
        owner_ref: 'System:1')).target
  }
  let(:existing_link) {
    Moogle::Commands::CreateLink.call(
      Moogle::Requests::CreateLink.new(
        target_id: existing_target.id,
        receiver_ref: 'Gym:1',
        message_kind: 'my_message_kind',
        render_options: { 'nada_parameter' => 'some_value'})).link
  }
  let(:request_hash) {{
    link_id: existing_link.id
  }}
  let(:request) {
    Moogle::Requests::SuspendLink.new request_hash
  }
  let(:command) {
    Moogle::Commands::SuspendLink
  }

  it 'should suspend existing link' do
    result = command.call request
    result.kind.should == 'moogle/events/link_suspended'
    result.link.id.should == existing_link.id
    result.link.suspended.should == true
    result.request_uuid.should == request.uuid
  end

  it 'should be able to parse a hash as request' do
    result = command.call request
    result.kind.should == 'moogle/events/link_suspended'
    result.link.id.should == existing_link.id
    result.link.suspended.should == true
  end
end

describe 'Moogle::Commands::UnsuspendLink' do
  let(:existing_target) {
    Moogle::Commands::CreateTarget.call(
      Moogle::Requests::CreateTarget.new(
        type: :wordpress,
        owner_ref: 'System:1')).target
  }
  let(:existing_link) {
    Moogle::Commands::CreateLink.call(
      Moogle::Requests::CreateLink.new(
        target_id: existing_target.id,
        receiver_ref: 'Gym:1',
        message_kind: 'my_message_kind',
        render_options: { 'nada_parameter' => 'some_value'})).link
  }
  let(:request_hash) {{
    link_id: existing_link.id
  }}
  let(:request) {
    Moogle::Requests::UnsuspendLink.new request_hash
  }
  let(:command) {
    Moogle::Commands::UnsuspendLink
  }
  before do
    Moogle::Commands::SuspendLink.call(
      Moogle::Requests::SuspendLink.new(link_id: existing_link.id))
  end

  it 'should unsuspend existing link' do
    result = command.call request
    result.kind.should == 'moogle/events/link_unsuspended'
    result.link.id.should == existing_link.id
    result.link.suspended.should == false
    result.request_uuid.should == request.uuid
  end

  it 'should be able to parse a hash as request' do
    result = command.call request
    result.kind.should == 'moogle/events/link_unsuspended'
    result.link.id.should == existing_link.id
    result.link.suspended.should == false
  end
end
