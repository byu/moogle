require 'moogle/commands'
require 'moogle/handlers/accept_notification'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:moogle_db, 'sqlite::memory:')
DataMapper.auto_migrate!
