module Redshift
  class SchemaMigration < Redshift::Base
    attr_accessor :version

    def self.create_table
      return if self.exist_table?
      sql = 'CREATE TABLE IF NOT EXISTS schema_migrations(version VARCHAR(256));'
      execute(sql) do |_result|
        true
      end
    end

    def self.current_version
      sql = 'SELECT version FROM schema_migrations ORDER BY version DESC LIMIT 1;'
      execute(sql) do |result|
        result.first ? result.first['version'].to_i : 0
      end
    end

    def self.versions
      sql = 'SELECT version FROM schema_migrations ORDER BY version DESC;'
      execute(sql) do |result|
        result.map { |v| v['version'].to_i }
      end
    end
  end
end
