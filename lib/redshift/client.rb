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

  module Client
    class << self
      def configuration=(host: '', port: 5432, database: '', username: '', password: '', **_opt)
        @configuration = {
          host: host,
          port: port,
          database: database,
          username: username,
          password: password
        }
      end

      def configuration # rubocop:disable Style/TrivialAccessors
        @configuration
      end

      def connector
        Connector.new
      end
    end
  end
end
