module Mandy
  module Mappers
    class Base < Mandy::Task
      include Mandy::IO::Formatting
      
      def self.compile(&blk)
        Class.new(Mandy::Mappers::Base) do 
          self.class_eval do
            define_method(:mapper, blk) if blk
          end
        end
      end
      
      def execute
        @input.each_line do |line|
           key, value = line.split(KEY_VALUE_SEPERATOR, 2)
           key, value = nil, key if value.nil?
           value.chomp!
           mapper(input_deserialize_key(key), input_deserialize_value(value))
        end
      end

      def emit(key, value=nil)
        key = 'nil' if key.nil?
        @output.puts(value.nil? ? key.to_s : "#{serialize_key(key)}\t#{serialize_value(value)}")
      end
      
      private
    
      def mapper(key,value)
        #nil
      end
    end
  end
end