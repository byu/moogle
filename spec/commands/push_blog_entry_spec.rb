require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Commands::PushBlogEntry' do
  let(:request) {{
    target_id: 1,
    message_origin: 'btwb/events/workout_session_created',
    subject: 'My Test Title',
    html_body: 'Body of the blog post',
    categories: ['tag1', 'tag2'],
    rpc_uri: 'http://example.wordpress.com/xmlrpc.php',
    blog_uri: 'http://example.wordpress.com/',
    blog_id: 'my_blog_id',
    username: 'user@example.com',
    password: 'password',
    publish_immediately: true,
    uuid: '85d9e997-6dcd-499e-9a5d-09dc0dc8c3b4'
  }}
  let(:command) {
    Moogle::Commands::PushBlogEntry
  }

  it 'should push a blog entry' do
    VCR.use_cassette('push_blog_entry') do
      result = command.call request
      result.kind.should == 'moogle/events/blog_entry_pushed'
      result.post_ref.should == '61'
      result.target_id.should == request[:target_id]
      result.message_origin == request[:message_origin]
      result.request_uuid.should == request[:uuid]
    end
  end

end
