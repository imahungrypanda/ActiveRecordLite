require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'human', 'humans'
end

class SQLObject
  def self.columns
    return @columns if instance_variable_defined?("@columns")

    @columns = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        cats
    SQL

    @columns = @columns.first.map(&:to_sym)
  end

  def self.finalize!
  end

  def self.table_name=(table_name)
    define_method("#{table_name.downcase.pluralize}=") { |el| instance_variable_set("@#{table_name}", el) }
  end

  def self.table_name
    name.downcase.pluralize.to_s
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # ...
  end

  def attributes
    # ...
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
