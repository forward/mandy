module Mandy
  class Reducer
    
    KEY_VALUE_SEPERATOR = "\t" unless defined?(KEY_VALUE_SEPERATOR)
    
    def initialize(input=STDIN, output=STDOUT)
      @input, @output = input, output
    end
    
    def self.compile(&blk)
      Class.new(Mandy::Reducer) do 
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
    end
    
    def emit(key, value=nil)
      key = 'nil' if key.nil?
      @output.puts(value.nil? ? key.to_s : "#{key}\t#{value}")
    end
    
    private
    
    def reducer(key,value)
      # default reducer is simply a pass-through
      emit(key, value)
    end
  end
end