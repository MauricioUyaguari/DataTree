# DataTree


DataTree is a lightweight version of ActiveRecord.  Like ActiveRecord, DataTree's main goal is to connect Ruby classes to relational database tables stored in a SQL language.  In common applications these classes will be referred to as models.  These classes often have relationships between each other, which will be defined as assocations.   The purpose of DataTree is for a user to quickly and careful use SQL table name and relationship in a r


## Lib

The main lib consists of the following files
  * #sql_object.rb
  * #searchable.rb
  * #assocations.rb
  * #has_through.rb

### sql_object

This file contains the sql object class which contains a class to a SQL table.  It contains the following useful methods that will be used 
