module Mandy
  class Tuple
    
    SEPERATOR = ',' unless defined?(SEPERATOR)
    
    attr_accessor :name, :value
    
    def initialize(name, value, name_accessor = nil, value_accessor = nil)
      @name, @value = name, value
      alias_accessor(name_accessor, :name) unless name_accessor.nil?
      alias_accessor(value_accessor, :value) unless value_accessor.nil?
    end
    
    def to_s
      %(#{@name}#{SEPERATOR}#{@value})
    end
    
    def self.from_s(str)
      new(*str.split(SEPERATOR))
    end
    
    def inspect
      %(<Tuple #{self.to_s}>)
    end
    
    def ==(other)
      return false unless self.class == other.class
      self.name == other.name && self.value == other.value
    end
    
    private
    
    def alias_accessor(new_accessor, old_accessor)
      self.class.send(:alias_method, new_accessor, old_accessor)
      self.class.send(:alias_method, :"#{new_accessor}=", :"#{old_accessor}=")
    end
  end
end