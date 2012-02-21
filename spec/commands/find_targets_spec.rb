require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::Commands::FindTargets' do
  before {
    Moogle::WebhookTarget.create(
      owner_ref: 'System:1a',
      links: [
        Moogle::Link.new
      ])
  }
  let(:request_hash) {{
    owner_ref: 'System:1a'
  }}
  let(:request) {
    Moogle::Requests::FindTargets.new request_hash
  }
  let(:command) {
    Moogle::Commands::FindTargets
  }

  it 'should find the target with link' do
    result = command.call request
    result.size.should == 1
    result.first.kind.should == 'moogle/domain/target'
    result.first.owner_ref.should == 'System:1a'
    result.first.links.size.should == 1
  end
end
