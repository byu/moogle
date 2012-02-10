require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Commands::CreateLink' do
  let(:existing_target) {
    Moogle::Commands::CreateTarget.call(
      Moogle::Requests::CreateTarget.new(
        type: :webhook,
        owner_ref: 'System:1a'))
  }
  let(:request) {
    Moogle::Requests::CreateLink.new(
      target_id: existing_target.id,
      receiver_ref: 'Gym:1',
      message_kind: 'my_message_kind',
      render_options: { 'parameter' => 'value'})
  }
  let(:command) {
    Moogle::Commands::CreateLink
  }

  it 'should create a link' do
    result = command.call request
    result.message_kind.should == 'my_message_kind'
    result.receiver_ref.should == 'Gym:1'
    result.render_options.should == { 'parameter' => 'value' }
    result.suspended.should == false
  end
end

describe 'Moogle::Commands::DestroyLink' do
  let(:command) {
    Moogle::Commands::DestroyLink
  }

  describe 'with non-existent target' do
    let(:request) {
      Moogle::Requests::DestroyLink.new link_id: 12345
    }

    it 'should succeed' do
      result = command.call request
      result.should == true
    end
  end

  describe 'with existing link' do
    let(:existing_target) {
      Moogle::Commands::CreateTarget.call(
        Moogle::Requests::CreateTarget.new(
          type: :wordpress,
          owner_ref: 'System:1'))
    }
    let(:existing_link) {
      Moogle::Commands::CreateLink.call(
        Moogle::Requests::CreateLink.new(
          target_id: existing_target.id,
          receiver_ref: 'Gym:1',
          message_kind: 'my_message_kind',
          render_options: { 'parameter' => 'value'}))
    }
    let(:request) {
      Moogle::Requests::DestroyLink.new link_id: existing_link.id
    }

    it 'should succeed' do
      result = command.call request
      result.should == true
    end
  end
end

describe 'Moogle::Commands::UpdateLink' do
  let(:existing_target) {
    Moogle::Commands::CreateTarget.call(
      Moogle::Requests::CreateTarget.new(
        type: :wordpress,
        owner_ref: 'System:1'))
  }
  let(:existing_link) {
    Moogle::Commands::CreateLink.call(
      Moogle::Requests::CreateLink.new(
        target_id: existing_target.id,
        receiver_ref: 'Gym:1',
        message_kind: 'my_message_kind',
        render_options: { 'nada_parameter' => 'some_value'}))
  }
  let(:request) {
    Moogle::Requests::UpdateLink.new(
      link_id: existing_link.id,
      render_options: {
        parameter1: 'value1'
      })
  }
  let(:command) {
    Moogle::Commands::UpdateLink
  }

  it 'should update existing link' do
    result = command.call request
    result.render_options.should == { parameter1: 'value1' }
  end
end

describe 'Moogle::Commands::SuspendLink' do
  let(:existing_target) {
    Moogle::Commands::CreateTarget.call(
      Moogle::Requests::CreateTarget.new(
        type: :wordpress,
        owner_ref: 'System:1'))
  }
  let(:existing_link) {
    Moogle::Commands::CreateLink.call(
      Moogle::Requests::CreateLink.new(
        target_id: existing_target.id,
        receiver_ref: 'Gym:1',
        message_kind: 'my_message_kind',
        render_options: { 'nada_parameter' => 'some_value'}))
  }
  let(:request) {
    Moogle::Requests::SuspendLink.new link_id: existing_link.id
  }
  let(:command) {
    Moogle::Commands::SuspendLink
  }

  it 'should suspend existing link' do
    result = command.call request
    result.suspended.should == true
  end
end

describe 'Moogle::Commands::UnsuspendLink' do
  let(:existing_target) {
    Moogle::Commands::CreateTarget.call(
      Moogle::Requests::CreateTarget.new(
        type: :wordpress,
        owner_ref: 'System:1'))
  }
  let(:existing_link) {
    Moogle::Commands::CreateLink.call(
      Moogle::Requests::CreateLink.new(
        target_id: existing_target.id,
        receiver_ref: 'Gym:1',
        message_kind: 'my_message_kind',
        render_options: { 'nada_parameter' => 'some_value'}))
  }
  let(:request) {
    Moogle::Requests::UnsuspendLink.new link_id: existing_link.id
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
    result.suspended.should == false
  end
end
