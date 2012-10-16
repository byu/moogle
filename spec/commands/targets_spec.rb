require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Commands::CreateTarget' do
  let(:request) {
    Hashie::Mash.new(
      type: :blog,
      owner_ref: 'System:1',
      options: {
        'rpc_uri' => 'http://example.com/target',
        'blog_uri' => 'http://example.com/',
        'blog_id' => 'example_blog_name',
        'username' => 'username',
        'password' => 'password',
        'publish_immediately' => true
      })
  }
  let(:command) {
    Moogle::Commands::CreateTarget
  }

  it 'should create a target' do
    result = command.call nil, request
    result.kind.should == 'moogle/events/target_created'
    result.parent_uuid.should == request[:uuid]
    result.target.type.should == 'blogs'
    result.target.owner_ref.should == 'System:1'
    result.target.options.should == {
      'rpc_uri' => 'http://example.com/target',
      'blog_uri' => 'http://example.com/',
      'blog_id' => 'example_blog_name',
      'username' => 'username',
      'password' => 'password',
      'publish_immediately' => true
    }
  end
end

describe 'Moogle::Commands::DestroyTarget' do
  let(:request) {
    Hashie::Mash.new(
      target_id: 12345)
  }
  let(:command) {
    Moogle::Commands::DestroyTarget
  }

  describe 'with non-existent target' do
    it 'should succeed' do
      result = command.call nil, request
      result.kind.should == 'moogle/events/target_destroyed'
      result.parent_uuid.should == request[:uuid]
      result.target_id.should == 12345
    end
  end

  describe 'with existing target' do
    let(:existing_target) {
      Moogle::BlogTarget.create(
        owner_ref: 'System:1a',
        options: {
          'rpc_uri' => 'http://example.com/target',
          'blog_uri' => 'http://example.com/',
          'blog_id' => 'example_blog_name',
          'username' => 'username',
          'password' => 'password',
          'publish_immediately' => true
        })
    }
    let(:request) {
      Hashie::Mash.new(
        target_id: existing_target.id)
    }

    it 'should succeed' do
      result = command.call nil, request
      result.kind.should == 'moogle/events/target_destroyed'
      result.parent_uuid.should == request[:uuid]
      result.target_id.should == existing_target.id
    end
  end
end

describe 'Moogle::Commands::UpdateTarget' do
  let(:existing_target) {
    Moogle::BlogTarget.create(
      owner_ref: 'System:1a',
      options: {
        'rpc_uri' => 'http://example.com/target',
        'blog_uri' => 'http://example.com/',
        'blog_id' => 'example_blog_name',
        'username' => 'username',
        'password' => 'password',
        'publish_immediately' => true
      })
  }
  let(:request) {
    Hashie::Mash.new(
      target_id: existing_target.id,
      options: {
        'rpc_uri' => 'http://example.com/target',
        'blog_uri' => 'http://example.com/',
        'blog_id' => 'example_blog_name',
        'username' => 'username',
        'password' => 'password',
        'publish_immediately' => false
      })
  }
  let(:command) {
    Moogle::Commands::UpdateTarget
  }

  it 'should update existing target' do
    result = command.call nil, request
    result.kind.should == 'moogle/events/target_updated'
    result.parent_uuid.should == request[:uuid]
    result.target.options.should == {
      'rpc_uri' => 'http://example.com/target',
      'blog_uri' => 'http://example.com/',
      'blog_id' => 'example_blog_name',
      'username' => 'username',
      'password' => 'password',
      'publish_immediately' => false
    }
  end
end
