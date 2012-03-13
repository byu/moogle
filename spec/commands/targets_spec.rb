require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Commands::CreateTarget' do
  let(:request_hash) {{
    type: :blog,
    owner_ref: 'System:1',
    options: {
      'rpc_uri' => 'http://example.com/target',
      'blog_uri' => 'http://example.com/',
      'blog_id' => 'example_blog_name',
      'username' => 'username',
      'password' => 'password',
      'publish_immediately' => true
    }
  }}
  let(:request) {
    Moogle::Requests::CreateTarget.new request_hash
  }
  let(:command) {
    Moogle::Commands::CreateTarget
  }

  it 'should create a target' do
    result = command.call request
    result.kind.should == 'moogle/events/target_created'
    result.request_uuid.should == request.uuid
    result.target.type.should == Moogle::BlogTarget
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

  it 'should be able to parse a hash as request' do
    result = command.call request_hash
    result.kind.should == 'moogle/events/target_created'
    result.target.type.should == Moogle::BlogTarget
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
  let(:request_hash) {{
    target_id: 12345
  }}
  let(:command) {
    Moogle::Commands::DestroyTarget
  }

  describe 'with non-existent target' do
    let(:request) {
      Moogle::Requests::DestroyTarget.new request_hash
    }

    it 'should succeed' do
      result = command.call request
      result.kind.should == 'moogle/events/target_destroyed'
      result.request_uuid.should == request.uuid
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
      Moogle::Requests::DestroyTarget.new target_id: existing_target.id
    }

    it 'should succeed' do
      result = command.call request
      result.kind.should == 'moogle/events/target_destroyed'
      result.request_uuid.should == request.uuid
      result.target_id.should == existing_target.id
    end
  end

  it 'should be able to parse a hash as request' do
    result = command.call request_hash
    result.kind.should == 'moogle/events/target_destroyed'
    result.target_id.should == 12345
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
  let(:request_hash) {{
    target_id: existing_target.id,
    options: {
      'rpc_uri' => 'http://example.com/target',
      'blog_uri' => 'http://example.com/',
      'blog_id' => 'example_blog_name',
      'username' => 'username',
      'password' => 'password',
      'publish_immediately' => false
    }
  }}
  let(:request) {
    Moogle::Requests::UpdateTarget.new request_hash
  }
  let(:command) {
    Moogle::Commands::UpdateTarget
  }

  it 'should update existing target' do
    result = command.call request
    result.kind.should == 'moogle/events/target_updated'
    result.request_uuid.should == request.uuid
    result.target.options.should == {
      'rpc_uri' => 'http://example.com/target',
      'blog_uri' => 'http://example.com/',
      'blog_id' => 'example_blog_name',
      'username' => 'username',
      'password' => 'password',
      'publish_immediately' => false
    }
  end

  it 'should be able to parse a hash as request' do
    result = command.call request
    result.kind.should == 'moogle/events/target_updated'
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
