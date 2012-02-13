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

  it 'should find for moogle/requests/suspend_link' do
    result = subject.call(kind: 'moogle/requests/suspend_link')
    result.should == Moogle::Commands::SuspendLink
  end

  it 'should find for moogle/requests/unsuspend_link' do
    result = subject.call(kind: 'moogle/requests/unsuspend_link')
    result.should == Moogle::Commands::UnsuspendLink
  end

  it 'should find for moogle/requests/update_link' do
    result = subject.call(kind: 'moogle/requests/update_link')
    result.should == Moogle::Commands::UpdateLink
  end

  it 'should find for moogle/requests/update_target' do
    result = subject.call(kind: 'moogle/requests/update_target')
    result.should == Moogle::Commands::UpdateTarget
  end

end
