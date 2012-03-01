require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::CommandFinder' do
  subject { Moogle::CommandFinder }

  it 'should find for moogle/requests/create_link' do
    result = subject.call(kind: 'moogle/requests/create_link')
    result.should == Moogle::Commands::CreateLink
  end

  it 'should find for moogle/requests/create_target' do
    result = subject.call(kind: 'moogle/requests/create_target')
    result.should == Moogle::Commands::CreateTarget
  end

  it 'should find for moogle/requests/destroy_link' do
    result = subject.call(kind: 'moogle/requests/destroy_link')
    result.should == Moogle::Commands::DestroyLink
  end

  it 'should find for moogle/requests/destroy_target' do
    result = subject.call(kind: 'moogle/requests/destroy_target')
    result.should == Moogle::Commands::DestroyTarget
  end

  it 'should find for moogle/requests/find_targets' do
    result = subject.call(kind: 'moogle/requests/find_targets')
    result.should == Moogle::Commands::FindTargets
  end

  it 'should find for moogle/requests/update_target' do
    result = subject.call(kind: 'moogle/requests/update_target')
    result.should == Moogle::Commands::UpdateTarget
  end

end
