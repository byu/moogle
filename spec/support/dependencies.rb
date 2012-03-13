require 'moogle/commands'
require 'moogle/handlers/accept_notification'
require 'moogle/requests'

Aequitas::Violation.default_transformer =
  Aequitas::MessageTransformer::DefaultStatic.new

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.auto_migrate!
