module Mandy
  module Mappers
    class Base
      
      KEY_VALUE_SEPERATOR = "\t" unless defined?(KEY_VALUE_SEPERATOR)
    
      def initialize(input=STDIN, output=STDOUT)
        @input, @output = input, output
      end
    
      def self.compile(&blk)
        Class.new(Mandy::Mappers::Base) do 
          self.class_eval do
            define_method(:mapper, blk) if blk
          end
        end
      end
    
      def execute
        @input.each_line do |line|
           key, value = line.split(KEY_VALUE_SEPERATOR)
           key, value = nil, key if value.nil?
           value.chomp!
           mapper(key, value)
        end
      end
    
      def emit(key, value=nil)
        key = 'nil' if key.nil?
        @output.puts(value.nil? ? key.to_s : "#{serialize(key)}\t#{serialize(value)}")
      end
    
      private
    
      def mapper(key,value)
        #nil
      end
      
      def serialize(value)
        value = ArraySerializer.new(value) if value.is_a?(Array)
        value.to_s
      end
    end
  end
end