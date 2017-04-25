class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method(name) { instance_variable_get("@#{name}") }
      define_method(:"#{name}=") { |el| instance_variable_set("@#{name}", el) }
    end
  end
end
