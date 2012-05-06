require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Commands::FindTargets' do
  before {
    Moogle::WebhookTarget.create(
      owner_ref: 'System:1a',
      options: {
        'webhook_uri' => 'http://example.com/target'
      },
      links: [
        Moogle::Link.new
      ])
  }
  let(:request) {{
    owner_ref: 'System:1a'
  }}
  let(:command) {
    Moogle::Commands::FindTargets
  }

  it 'should find the target with link' do
    result = command.call request
    result.size.should == 1
    result.first.kind.should == 'moogle/domain/target'
    result.first.owner_ref.should == 'System:1a'
    result.first.options['webhook_uri'].should == 'http://example.com/target'
    result.first.links.size.should == 1
  end
end
