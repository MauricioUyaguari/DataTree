require_relative ''

module Associatable

  def has_one_through(name, through_name, source_name)

    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      through_table = through_options.table_name
      through_primary_key = through_options.primary_key
      source_options = through_options.model_class.assoc_options[source_name]
      source_table = source_options.table_name
      source_primary_key = source_options.primary_key
      source_foreign_key = source_options.foreign_key
      value = self.send(through_options.foreign_key)
      results = DBConnection.execute(<<-SQL, value)
      SELECT
      #{source_table}.*
      FROM
      #{through_table}
      JOIN
      #{source_table}
      ON
      #{through_table}.#{source_foreign_key} = #{source_table}.#{source_primary_key}
      WHERE
      #{through_table}.#{through_primary_key} = ?
      SQL
      return source_options.model_class.parse_all(results).first
    end
  end



  def has_many_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      through_table = through_options

    end

  end
end
