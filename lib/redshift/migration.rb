module Redshift
  MigrationProxy = Struct.new(:name, :version, :filename, :scope) do
    def initialize(name, version, filename, scope)
      super
      @migration = nil
    end

    delegate :migrate, to: :migration

    private

    def migration
      @migration ||= load_migration
    end

    def load_migration
      require(File.expand_path(filename))
      name.constantize.new(name, version)
    end
  end

  class Migration
    attr_accessor :name, :version

    def initialize(name, version)
      @name = name
      @version = version
    end

    def migrate(direction)
      case direction
      when :up
        up
      when :down
        down
      end
    end

    def up_sql
    end

    def up
      execute(up_sql)
      Redshift::SchemaMigration.create(version: version)
      p "[#{version}] up: #{name}"
    end

    def down_sql
    end

    def down
      execute(down_sql)
      Redshift::SchemaMigration.delete("version = '#{version}'")
      p "[#{version}] down: #{name}"
    end

    def execute(sql)
      cnct = Redshift::Client.connector
      cnct.execute(sql)
      cnct.close
    end
  end
end
