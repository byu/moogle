require 'moogle/commands'
require 'moogle/handlers/accept_notification'
require 'moogle/requests'

Aequitas::Violation.default_transformer =
  Aequitas::MessageTransformer::DefaultStatic.new

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:moogle_db, 'sqlite::memory:')
DataMapper.auto_migrate!
