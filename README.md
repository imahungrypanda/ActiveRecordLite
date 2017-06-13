# Active Record Lite

## Description
Active Record Lite is a example of how Rails' version of Active Record could be implemented. This project helped to instill the concept of meta programming.

## Implementation Details

#### SQL Objects
- ::all - returns all instances of SQL object class
- ::find(id) - returns instance of SQL object class with provided id
- ::columns - returns SQL object class's columns
- ::table_name - returns SQL object class's table name
- ::table_name=(table_name) - renames SQL object's table name
- \#save - saves SQL object to database
- \#attributes - lists SQL object's attributes
- \#attribute_values - lists SQL object's attribute values
- \#update - Updates SQL object's attributes

#### Insert
Most of the methods rely on using `DBConnection.execute2` to get the data from the database. This is a sample of how I made insert:

```ruby
  def insert
    columns = self.class.columns.drop(1)
    col_names = columns.map(&:to_s).join(", ")
    question_marks = ( ["?"] * columns.length ).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end
```

#### "Where" Searches
Another method that was implemented was `where`. Using a similar query to insert a user is able to find exactly what is specified:

```ruby
def where(params)
  where = params.keys.map { |key| "#{key} = ?" }.join(" AND ")

  result = DBConnection.execute(<<-SQL, *params.values)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      #{where}
  SQL

  parse_all(result)
end
```


#### Object relationships

On top of the other methods implemented Associations have been added. This  allows allows different SQL classes to be related to one another through the traditional `belongs_to` and `has_many` relationships. Here is an how they work:

```ruby
class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      foreign_key: "#{name}_id".to_sym,
      class_name: name.to_s.camelcase,
      primary_key: :id
    }

    defaults.keys.each do |key|
      self.send("#{key}=", options[key] || defaults[key])
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      foreign_key: "#{self_class_name}_id".downcase.to_sym,
      class_name: name.to_s.singularize.camelcase,
      primary_key: :id
    }

    defaults.keys.each do |key|
      self.send("#{key}=", options[key] || defaults[key])
    end
  end
end
```