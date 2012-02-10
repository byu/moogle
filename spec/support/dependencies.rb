require 'moogle/commands/create_target'
require 'moogle/commands/destroy_target'
require 'moogle/commands/update_target'

require 'moogle/commands/create_link'
require 'moogle/commands/destroy_link'
require 'moogle/commands/update_link'
require 'moogle/commands/suspend_link'
require 'moogle/commands/unsuspend_link'

require 'moogle/messages/requests/create_target'
require 'moogle/messages/requests/destroy_target'
require 'moogle/messages/requests/update_target'
require 'moogle/messages/requests/suspend_link'
require 'moogle/messages/requests/unsuspend_link'

require 'moogle/messages/requests/create_link'
require 'moogle/messages/requests/destroy_link'
require 'moogle/messages/requests/update_link'


Aequitas::Violation.default_transformer =
  Aequitas::MessageTransformer::DefaultStatic.new

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.auto_migrate!
