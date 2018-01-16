require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    table = self.table_name
    if @output.nil? 
      @output = DBConnection.execute2(<<-SQL)
      SELECT
        *
        FROM
        #{table} 
        limit 0
        SQL
    
        @output = @output[0].map! { |col| col.to_sym }
    else 
      @output
    end
  end

  def self.finalize!

     self.columns.each do |table_col|
            
       define_method(table_col.to_s) do 
         self.attributes[table_col.to_sym]
       end    
       define_method("#{table_col.to_s}=") do |to_set|
         self.attributes[table_col.to_sym] = to_set
       end 
    end   

  end

  def self.table_name=(table_name)
    #@table_name = table_name.tableize
    #self.instance_variable_set(self.table_name, table_name) 
    # ...
    @table_name = table_name
  end

  def self.table_name
    #self.to_s.tableize
    # ...
    
    @table_name ||= self.to_s.tableize
  end

  def self.all
    table = self.table_name
    all = DBConnection.execute2(<<-SQL)
    SELECT
      *
      FROM
      #{table} 
      SQL
    all = all[1..-1]
    self.parse_all(all)
  end

  def self.parse_all(results)
    final = []
    results.each do |result|
      final << self.new(result)
    end 
    final
  end

  def self.find(id)
    table = self.table_name
    all = DBConnection.execute(<<-SQL)
    SELECT
      *
      FROM
      #{table}
      where
      id = #{id} 
    SQL
  #  debugger
    p all.nil?
  return nil if all.empty?
  self.new(all[0])
  
  end

  def initialize(params = {})
    columns = self.class.columns
    params.each do |param| 
    raise "unknown attribute '#{param[0].to_s}'" if columns.include?(param[0].to_sym) == false
    send("#{param[0]}=",param[1])
    end 

  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    all =  self.attributes
    result = []
    
    all.each do |el|
      result << el[1]
    end
    result
  end

  def insert
    table_name = self.class.table_name
    columns = self.class.columns
    unique = columns[1..-1].join(",")
    values = self.attribute_values.join(",")

    # debugger
    questions = (["?"] * (columns.count-1)).join(",")
        
    # p columns, table_name, unique , questions
    # DBConnection.execute(<<-SQL, #{values})
    # INSERT INTO
    #   #{table_name} (#{unique})
    # VALUES
    #   (#{questions})
    # SQL
    
    
    
    
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
