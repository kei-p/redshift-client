require "redshift/client/version"

require 'active_support'
require 'active_support/core_ext'
require 'yaml'
require 'pg'

module Redshift
  autoload :Base, 'redshift/base'
  autoload :Connector, 'redshift/connector'
  autoload :Query, 'redshift/query'
  autoload :Migrator, 'redshift/migrator'
  autoload :MigrationProxy, 'redshift/migration'
  autoload :Migration, 'redshift/migration'
  autoload :SchemaMigration, 'redshift/schema_migration'
end
