module Mandy
  class Tuple
    
    SEPERATOR = ',' unless defined?(SEPERATOR)
    
    attr_accessor :name, :value
    
    def initialize(name, value)
      @name, @value = name, value
    end
    
    def to_s
      %(#{@name}#{SEPERATOR}#{@value})
    end
    
    def self.from_s(str)
      new(*str.split(SEPERATOR))
    end
    
    def ==(other)
      self.name == other.name && self.value == other.value
    end
  end
end