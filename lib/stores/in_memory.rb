module Mandy
  module Stores
    class InMemory
      attr_reader :options
      
      def initialize(options={})
        @options = options
        @table = {}
      end
      
      def get(key)
        @table[key.to_s]
      end
      
      def put(key, values)
        @table[key.to_s] = values
      end
      
      def ==(other)
        self.class == other.class && self.options == other.options
      end
    end
  end
end