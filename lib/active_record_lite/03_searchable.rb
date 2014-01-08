require_relative 'db_connection'
require_relative '02_sql_object'

module Searchable
  def where(params)
    where_condition = params.keys.map { |attribute| "#{attribute} = ? " }.join(" AND ")
    values = params.values
    
    results = DBConnection.execute(<<-SQL, *values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_condition}
    SQL
    
    parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
