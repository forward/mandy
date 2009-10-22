module Mandy
  class Task
    KEY_VALUE_SEPERATOR = "\t" unless defined?(KEY_VALUE_SEPERATOR)
    NUMERIC_PADDING = 16
    DEFAULT_COUNTER_GROUP = 'Mandy Counters'
    
    attr_reader :input_format, :output_format
    
    def initialize(input=STDIN, output=STDOUT, input_format = nil, output_format = nil)
      @input, @output = input, output
      @input_format, @output_format = input_format, output_format
    end

    def emit(key, value=nil)
      data = value.nil? ? key.to_s : "#{output_serialize_key(key)}\t#{output_serialize_value(value)}"
      @output.puts data.chomp
    end
    
    def get(store, key)
      Mandy.stores[store].get(key)
    end

    def put(store, key, values)
      Mandy.stores[store].put(key, values)
    end

    private
    def pad(key)
      key_parts = key.to_s.split(".")
      key_parts[0] = key_parts.first.rjust(NUMERIC_PADDING, '0')
      key_parts.join('.')
    end
    
    def update_status(message)
      STDERR.puts("reporter:status:#{message}")
    end
    
    def increment_counter(group, counter=nil, count=1)
      group, counter = DEFAULT_COUNTER_GROUP, group if counter.nil?
      group, counter, count = DEFAULT_COUNTER_GROUP, group, counter if counter.is_a?(Numeric)
      
      STDERR.puts("reporter:counter:#{group},#{counter},#{count}")
    end
    
    def parameter(name)
      Job.parameter(name)
    end
    
    def deserialize_key(key)
      key
    end
    
    def deserialize_value(value)
      value
    end
    
    def serialize_key(key)
      key = pad(key) if key.is_a?(Numeric) && key.to_s.length < NUMERIC_PADDING
      key
    end

    def serialize_value(value)
      value = ArraySerializer.new(value) if value.is_a?(Array)
      value.to_s
    end
    
    def output_serialize_key(key)
      serialize_key(key)
    end

    def output_serialize_value(value)
      serialize_value(value)
    end
    
  end
end