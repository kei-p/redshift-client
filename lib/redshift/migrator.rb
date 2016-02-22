module Redshift
  class Migrator
    attr_accessor :migration_path, :current_version, :target_version

    def self.setup
      Redshift::SchemaMigration.create_table
    end

    def migration_files
      Dir.glob(File.join(migration_path, '*.rb'))
    end

    def target_version=(version)
      fail '存在しないversionです' unless migrations.map(&:version).include?(version)
      @target_version = version
    end

    attr_reader :target_version

    def current_version
      @current_version ||= Redshift::SchemaMigration.current_version
    end

    def db_versions
      @db_versions ||= Redshift::SchemaMigration.versions
    end

    def rollback_version(step)
      fail 'step数が不正です' unless step > 0
      m_versions = migrations.map(&:version)
      current_index = m_versions.index(current_version)
      t_index = current_index - (step)
      fail 'step数が不正です' unless t_index >= 0
      m_versions[t_index]
    end

    def migrations
      migrations = migration_files.map do |file_path|
        version, name, scope = file_path.scan(/([0-9]+)_([_a-z0-9]*)\.?([_a-z0-9]*)?\.rb\z/).first

        version = version.to_i
        name = name.camelize

        MigrationProxy.new(name, version, file_path, scope)
      end

      fail 'migration ファイルがありません' unless migrations.length > 0
      migrations.sort_by(&:version)
    end

    # rubocop:disable Metrics/AbcSize

    def migrate
      exec_migs = []

      t_version = target_version ? target_version : migrations.last.version

      if t_version > current_version ## up
        exec_migs = migrations.select { |mig| current_version < mig.version && mig.version <= t_version }
      elsif t_version < current_version ## down
        fail '指定された version が current_version よりも古いです'
      end

      print "current_version: #{current_version}  >> version: #{t_version}\n"

      exec_migs.each do |m|
        m.migrate(:up)
      end
    end

    def rollback
      exec_migs = []

      t_version = target_version ? target_version : rollback_version(1)

      if t_version > current_version ## up
        fail '指定された version が current_version よりも新しいです'
      elsif t_version < current_version ## down
        exec_migs = migrations.select { |mig| t_version < mig.version && mig.version <= current_version }.reverse
      end

      print "current_version: #{current_version}  >> version: #{t_version}\n"

      exec_migs.each do |m|
        m.migrate(:down)
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
