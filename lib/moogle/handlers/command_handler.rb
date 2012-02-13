require 'moogle/commands'
require 'moogle/messages/events/error'

module Moogle

  ##
  # Moogle command handlers to receive commands from serfapp, lookup the
  # command from the env hash and then execute the command. Any raised error
  # will be caught and wrapped in a Moogle::Error message and returned
  # to the caller (i.e. the SerfApp runner, and client caller).
  class CommandHandler

    ##
    # @option opts [#call] :command_finder The command class lookup.
    # @option opts [Class] :error_event_class The error message class.
    #
    def initialize(options={})
      @command_finder = options[:command_finder] || Moogle::CommandFinder
      @error_event_class = options[:error_event_class] || Moogle::Events::Error
    end

    ##
    # SerfApp call that receives hash
    #
    # @param [Hash] the rack-like serf message hash.
    # @return [Message] the command results, or error message.
    #
    def call(env)
      return @command_finder.call(env).call(env)
    rescue => e
      return @error_event_class.new(
        exception_class: e.class,
        message: e.message,
        backtrace: e.backtrace.join("\n"),
        request: env)
    end

  end

end
