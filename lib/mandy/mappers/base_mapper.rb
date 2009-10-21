module Mandy
  module Mappers
    class Base < Mandy::Task
      include Mandy::IO::InputFormatting

      def self.compile(opts={}, &blk)
        Class.new(Mandy::Mappers::Base) do 
          self.class_eval do
            define_method(:mapper, blk) if blk
            define_method(:setup, opts[:setup]) if opts[:setup]
            define_method(:teardown, opts[:teardown]) if opts[:teardown]
          end
        end
      end
      
      def execute
        setup if self.respond_to?(:setup)
        @input.each_line do |line|
           key, value = line.split(KEY_VALUE_SEPERATOR, 2)
           key, value = nil, key if value.nil?
           value.chomp!
           args = [input_deserialize_key(key), input_deserialize_value(value)].compact
           mapper(*args)
        end
        teardown if self.respond_to?(:teardown)
      end

      private
    
      def mapper(key,value)
        #nil
      end
    end
  end
end