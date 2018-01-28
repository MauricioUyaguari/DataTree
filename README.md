# DataTree

DataTree is an Object Relational Mapping (ORM) system.  DataTree is a lightweight version of ActiveRecord.  Like ActiveRecord, DataTree's main goal is to connect Ruby classes to relational database tables stored in a SQL language.  In common applications these classes will be referred to as models.  These classes often have relationships between each other, which will be defined as associations.

![ORM](/images/ORM.jpg)
## Lib

The main lib consists of the following files
  * #sql_object.rb
  * #searchable.rb
  * #associations.rb
  * #has_through.rb

### sql_object

This file contains the sql object class which connects itself to a sql table.  It also contains the following methods that might be helpful for the user:
  * #update
  * #insert
  * #save
  * #all
  * #find

A quick example is the all method shown below:
```ruby
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
```

## searchable.rb
One of the most useful methods that is used in SQl is where and this file contains this method which can be used with the sql object.

```ruby
def where(params)
  where_line = params.map{|key, value| "#{key} = ?"}.join(" AND ")
  results = DBConnection.execute(<<-SQL, *params.values)
    SELECT
    *
    FROM
    #{table_name}
    WHERE
    #{where_line}
  SQL
  parse_all(results)
end
```

## associations.rb

One of the most powerful features of DataTree is its ability to connect different SQL tables through their corresponding classes through associations.  Here we established the two most important associations between two tables.
  *#belongs_to
  *has_many

## has_through.rb

Going further another useful association is one born between two corresponding associations.  This one was for a has_one through two belongs_to relationships.


## db_connection.rb
This file contains some setup information for the futbul.sql file which created the soccer_players, teams and leagues tables.

# Going further

This library will be helpful in grabbing and manipulating data to meet the needs of the developer quickly and without much configuration.

## To Do
  * Continue to add more methods and joins betweens classes
