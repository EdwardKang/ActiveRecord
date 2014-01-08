require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject
  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end
end

class SQLObject < MassObject
  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.name.underscore.pluralize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      #{table_name}
    SQL
    
    self.parse_all(results)
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
    SELECT
      *
    FROM 
      #{table_name}
    WHERE
      #{table_name}.id = ?
    
    SQL
    
    self.parse_all(results)[0]
  end

  def insert
    cols = self.class.attributes.join(", ")
    
    values = []
    self.class.attributes.count.times { |num| values << "?" } 
    values = values.join(", ")
    
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{cols})
      VALUES
        (#{values})
      
    SQL
    
    self.id = DBConnection.last_insert_row_id
  end

  def save
    if id.nil? 
      insert
    else
      update
    end
  end

  def update
    cols = self.class.attributes.map { |attr| "#{attr} = ?" }
    cols_with_values = cols.join(", ")
    
    DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{cols_with_values}
      WHERE
        #{self.class.table_name}.id = ?
    SQL
  end

  def attribute_values
    self.class.attributes.map { |attr| self.send(attr) }
  end
end
