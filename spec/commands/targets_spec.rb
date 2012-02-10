require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Commands::CreateTarget' do
  let(:request) {
    Moogle::Requests::CreateTarget.new(
      type: :wordpress,
      owner_ref: 'System:1')
  }
  let(:command) {
    Moogle::Commands::CreateTarget
  }

  it 'should create a target' do
    result = command.call request

    result.type.should == Moogle::WordpressTarget
    result.owner_ref.should == 'System:1'
    result.options.should == {}
  end
end

describe 'Moogle::Commands::DestroyTarget' do
  let(:command) {
    Moogle::Commands::DestroyTarget
  }

  describe 'with non-existent target' do
    let(:request) {
      Moogle::Requests::DestroyTarget.new target_id: 12345
    }

    it 'should succeed' do
      result = command.call request
      result.should == true
    end
  end

  describe 'with existing target' do
    let(:existing_target) {
      Moogle::Commands::CreateTarget.call(
        Moogle::Requests::CreateTarget.new(
          type: :wordpress,
          owner_ref: 'System:1'))
    }
    let(:request) {
      Moogle::Requests::DestroyTarget.new target_id: existing_target.id
    }

    it 'should succeed' do
      result = command.call request
      result.should == true
    end
  end
end

describe 'Moogle::Commands::UpdateTarget' do
  let(:existing_target) {
    Moogle::Commands::CreateTarget.call(
      Moogle::Requests::CreateTarget.new(
        type: :wordpress,
        owner_ref: 'System:1'))
  }
  let(:request) {
    Moogle::Requests::UpdateTarget.new(
      target_id: existing_target.id,
      options: {
        parameter1: 'value1'
      })
  }
  let(:command) {
    Moogle::Commands::UpdateTarget
  }

  it 'should update existing target' do
    result = command.call request
    result.options.should == { parameter1: 'value1' }
  end
end
