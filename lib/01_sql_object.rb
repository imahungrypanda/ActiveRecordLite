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
    self.columns.each do |name|
      define_method(name) do
        self.attributes[name]
      end

      define_method("#{name}=") do |value|
        self.attributes[name] = value
      end
    end
  end

  def self.table_name=(table_name)
    define_method("#{table_name.downcase.pluralize}=") do |el|
      instance_variable_set("@#{table_name}", el)
    end
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
    params.each do |name, value|
      name = name.to_sym

      if self.class.columns.include?(name)
        self.send("#{name}=", value)
      else
        raise "unknown attribute '#{name.to_s}'"
      end
    end


  end

  def attributes
    @attributes ||= {}
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
