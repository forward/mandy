module Mandy
  class Task
    KEY_VALUE_SEPERATOR = "\t" unless defined?(KEY_VALUE_SEPERATOR)

    def initialize(input=STDIN, output=STDOUT)
      @input, @output = input, output
    end

    def emit(key, value=nil)
      key = 'nil' if key.nil?
      @output.puts(value.nil? ? key.to_s : "#{serialize(key)}\t#{serialize(value)}")
    end

    def get(store, key)
      Mandy.stores[store].get(key)
    end

    def put(store, key, values)
      Mandy.stores[store].put(key, values)
    end

    private


    def serialize(value)
      value = ArraySerializer.new(value) if value.is_a?(Array)
      value.to_s
    end
  end
end