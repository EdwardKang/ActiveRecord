require_relative '00_attr_accessor_object.rb'

class MassObject < AttrAccessorObject
  def self.my_attr_accessible(*new_attributes)
    self.attributes.concat(new_attributes)
  end

  def self.attributes
    if self == MassObject 
      raise "must not call #attributes on MassObject directly"
    end
    
    @attributes ||= []
  end

  def initialize(params = {})
    params.each do |attr, value| 
      attr = attr.to_sym
      
      raise "mass assignment to unregistered attribute '#{attr}'" unless self.class.attributes.include?(attr)
    
      self.send("#{attr}=", value)
    end
  end
end
