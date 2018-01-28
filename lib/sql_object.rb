require_relative 'db_connection'
require 'active_support/inflector'


class SQLObject
  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

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
    columns = self.class.columns.drop(1).map{|col| col.to_s}
    questions = (["?"] * columns.count).join(", ")
    col_names = columns.join(", ")
    DBConnection.execute(<<-SQL, *attribute_values)
     INSERT INTO
       #{self.class.table_name} (#{col_names})
     VALUES
       (#{questions})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    columns = self.class.columns.map { |col| "#{col} = ? "}.join(",")
    DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
      #{self.class.table_name}
      SET
      #{columns}
      WHERE
      #{self.class.table_name}.id = ?
    SQL
  end

  def save
    if self.id == nil
      self.insert
    else
      self.update
    end
  end
end
