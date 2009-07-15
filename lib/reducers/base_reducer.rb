module Mandy
  module Reducers
    class Base
      KEY_VALUE_SEPERATOR = "\t" unless defined?(KEY_VALUE_SEPERATOR)
    
      def initialize(input=STDIN, output=STDOUT)
        @input, @output = input, output
      end
    
      def self.compile(&blk)
        Class.new(Mandy::Reducers::Base) do 
          self.class_eval do
            define_method(:reducer, blk) if blk
          end
        end
      end
    
      def execute
        last_key, values = nil, []
        @input.each_line do |line|
           key, value = line.split(KEY_VALUE_SEPERATOR)
           value.chomp!
           last_key = key if last_key.nil?
           if key != last_key
             reducer(last_key, values)
             last_key, values = key, []
           end
           values << value
        end
        reducer(last_key, values)
      end
    
      def emit(key, value=nil)
        key = 'nil' if key.nil?
        @output.puts(value.nil? ? key.to_s : "#{serialize(key)}\t#{serialize(value)}")
      end
    
      private
    
      def reducer(key,values)
        #nil
      end
      
      def serialize(value)
        value = ArraySerializer.new(value) if value.is_a?(Array)
        value.to_s
      end
    end
  end
end