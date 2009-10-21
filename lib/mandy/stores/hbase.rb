module Mandy
  module Stores
    class HBase
      attr_reader :options
      
      def initialize(options)
        @options = options
        @table = ::HBase::HTable.new(options[:url])
      end
      
      def get(key)
        @table.get(key)
      end
      
      def put(key, values)
        @table.put(key, values)
      end
      
      def ==(other)
        self.class == other.class && self.options == other.options
      end
    end
  end
end