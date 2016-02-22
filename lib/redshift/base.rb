module Redshift
  class Base
    include Redshift::Query

    def self.exist_table?
      sql = exist_table_sql
      execute(sql) do |result|
        result.first && result.first['?column?'].to_i > 0 ? true : false
      end
    end

    def update_attributes(attrs)
      attrs.keys.each do |k|
        instance_eval "self.#{k} = attrs[k]"
      end
    end

    def self.create(attrs, async: false)
      sql = insert_sql(attrs)
      value = nil
      execute(sql, async: async) do |_result|
        value = new
        value.update_attributes(attrs)
        if block_given?
          yield value
        else
          return value
        end
      end
    end

    def self.execute(sql, async: false)
      cnct = Redshift::Connector.new

      if async
        cnct.async_execute(sql) do |result|
          cnct.close
          yield result
        end
      else
        result = cnct.execute(sql)
        cnct.close
        yield result
      end
    end

    def self.exist?(where_query = nil, async: false)
      sql = exist_sql(where_query)
      value = nil
      execute(sql, async: async) do |result|
        value = result.first && result.first['?column?'].to_i > 0 ? true : false
        if block_given?
          yield value
        else
          return value
        end
      end
    end

    def self.count(where_query = nil, async: false)
      sql = count_sql(where_query)
      value = nil
      execute(sql, async: async) do |result|
        value = result.first['count'].to_i
        if block_given?
          yield value
        else
          return value
        end
      end
    end

    def self.delete(where_query, async: false)
      sql = delete_sql(where_query)
      value = nil
      execute(sql, async: async) do |_result|
        value = true
        if block_given?
          yield value
        else
          return value
        end
      end
    end

    def self.delete_all(async: false)
      sql = delete_sql(nil)
      value = nil
      execute(sql, async: async) do |_result|
        value = true
        if block_given?
          yield value
        else
          return value
        end
      end
    end
  end
end
