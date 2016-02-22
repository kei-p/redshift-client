module Redshift
  module Query
    def table_name
      cls = self.class != Class ? self.class : self
      cls.to_s.split('::').last
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
        .pluralize
    end

    def where_sql(where)
      if !where || where.blank?
        ''
      else
        "WHERE #{where}"
      end
    end

    def exist_table_sql
      "SELECT 1 FROM pg_class WHERE relkind = 'r' AND relname = '#{table_name}'"
    end

    def exist_sql(where)
      "SELECT 1 FROM #{table_name} #{where_sql(where)} LIMIT 1;"
    end

    def count_sql(where)
      "SELECT COUNT(1) FROM #{table_name} #{where_sql(where)};"
    end

    def find_sql(_where_query)
      "SELECT * FROM #{table_name} #{where_sql(where)};"
    end

    def insert_sql(attrs)
      keys_str = attrs.keys.join(', ')
      values_str = attrs.values.map { |v| "'#{v}'" }.join(', ')
      "INSERT INTO #{table_name} (#{keys_str}) VALUES (#{values_str});"
    end

    def delete_sql(where)
      "DELETE FROM #{table_name} #{where_sql(where)};"
    end

    def self.included(mod)
      mod.extend self
    end
  end
end
