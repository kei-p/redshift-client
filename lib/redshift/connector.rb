module Redshift
  class Connector
    def initialize(host: nil, port: 5432, database: nil, username: nil, password: nil, **_opt)
      if host && database && username && password
        self.configuration = {
          host: host,
          port: port,
          database: database,
          username: username,
          password: password
        }
      else
        self.configuration = Connector.default_configuration
      end
    end

    def self.default_configuration=(host: '', port: 5432, database: '', username: '', password: '', **_opt)
      @default_configuration = {
        host: host,
        port: port,
        database: database,
        username: username,
        password: password
      }
    end

    def self.default_configuration # rubocop:disable Style/TrivialAccessors
      @default_configuration
    end

    def configuration=(host: '', port: 5432, database: '', username: '', password: '')
      @configuration = {
        host: host,
        port: port,
        database: database,
        username: username,
        password: password
      }
    end

    attr_reader :configuration
    RedshiftTableStruct = Struct.new(:schema, :table, :column, :type, :encoding, :dist_key, :sort_key, :not_null)

    def table_def(table_name)
      sql = "SELECT * FROM pg_table_def WHERE schemaname = 'public' AND tablename = '#{table_name}'"
      result = execute(sql)
      result.map do |v|
        RedshiftTableStruct.new(
          v['schemaname'],
          v['tablename'],
          v['column'],
          v['type'],
          v['encoding'],
          v['distkey'],
          v['sortkey'],
          v['notnull']
        )
      end
    end

    def execute(sql)
      config = configuration
      @cnct = PG::Connection.open(
        host: config[:host],
        port: config[:port],
        dbname: config[:database],
        user: config[:username],
        password: config[:password]
      )

      @cnct.exec(sql)
    end

    def async_execute(sql)
      config = configuration
      @cnct = PG::Connection.open(
        host: config[:host],
        port: config[:port],
        dbname: config[:database],
        user: config[:username],
        password: config[:password]
      )

      Thread.new do
        @cnct.async_exec(sql) do |result|
          yield result
        end
      end
      @cnct
    end

    def close
      @cnct.close
    end
  end
end