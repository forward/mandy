module Mandy
  module Reducers
    class Base < Mandy::Task
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
    
      private
    
      def reducer(key,values)
        #nil
      end
    end
  end
end