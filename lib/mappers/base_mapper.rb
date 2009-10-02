module Mandy
  module Mappers
    class Base < Mandy::Task
      include Mandy::IO::InputFormatting

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
           args = [input_deserialize_key(key), input_deserialize_value(value)].compact
           mapper(*args)
        end
      end

      private
    
      def mapper(key,value)
        #nil
      end
    end
  end
end