module Mandy
  module Reducers
    class Base < Mandy::Task
      include Mandy::IO::Formatting
      
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
        reducer(deserialize_key(last_key), values.map {|v| deserialize_value(v) })
      end
    
      def emit(key, value=nil)
        key = 'nil' if key.nil?
        @output.puts(value.nil? ? key.to_s : "#{output_serialize_key(key)}\t#{output_serialize_value(value)}")
      end
    
      private
      
      def reducer(key,values)
        #nil
      end
    end
  end
end