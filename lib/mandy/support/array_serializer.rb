module Mandy
  class ArraySerializer
    
    SEPERATOR = '|' unless defined?(SEPERATOR)
    
    attr_reader :items
    
    def initialize(items)
      @items = items || []
    end
    
    def to_s
      @items.join(SEPERATOR)
    end
    
    def ==(other)
      (self.class == other.class && self.items == other.items) || (other.is_a?(Array) && self.items == other)
    end
    
    def to_a
      @items
    end
    
    def self.from_s(str)
      str.split(SEPERATOR)
    end
    
    def self.tuples_from_s(str)
      from_s(str).map {|s| Tuple.from_s(s) }
    end
  end
end