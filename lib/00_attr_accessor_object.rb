class AttrAccessorObject

  def self.my_attr_accessor(*variables)
    variables.each do |variable|
      define_method(variable) do
        instance_variable_get("@#{variable.to_s}")
      end
      define_method("#{variable}=") do |to_set|
        instance_variable_set("@#{variable.to_s}", to_set)
      end
    end
  end 
end


class Test < AttrAccessorObject
my_attr_accessor :name

def initialize(name)
  @name = name
end

end
