require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Moogle::CommandHandler' do
  # Set some error messages
  let(:bad_command_error_message) { 'Bad Command Error' }
  let(:not_found_error_message) { '404 not found' }

  # Set up the command requests
  let(:good_request_hash) {{
    kind: 'moogle/requests/good_command'
  }}
  let(:bad_request_hash) {{
    kind: 'moogle/requests/bad_command'
  }}
  let(:fake_request_hash) {{
    kind: 'moogle/requests/fake_command'
  }}

  # Set up the Command objects to use
  let(:good_command) {
    Proc.new {
      true
    }
  }
  let(:bad_command) {
    Proc.new {
      raise bad_command_error_message
    }
  }

  # A simple command finder to map up the above commands.
  let(:command_finder) {
    Proc.new { |env|
      case env[:kind]
      when 'moogle/requests/good_command'
        good_command
      when 'moogle/requests/bad_command'
        bad_command
      else
        raise not_found_error_message
      end
    }
  }

  # This is our object under test.
  let(:handler) {
    Moogle::CommandHandler.new command_finder: command_finder
  }

  it 'should handle a message request with command' do
    result = handler.call good_request_hash
    result.should == true
  end

  it 'should handle exception with not-found command with an error event' do
    result = handler.call fake_request_hash
    result.kind.should == 'moogle/events/error'
    result.message.should == not_found_error_message
  end

  it 'should handle an exception raised from command with an error event' do
    result = handler.call bad_request_hash
    result.kind.should == 'moogle/events/error'
    result.message.should == bad_command_error_message
  end

end
