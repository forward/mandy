module Mandy
  class Task
    JSON_PAYLOAD_KEY = "json"
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
    
    def parameter(name)
      return find_json_param(name) if json_provided?
      ENV[name.to_s]
    end
    
    def find_json_param(name)
      @json_args ||= JSON.parse(ENV[JSON_PAYLOAD_KEY])
      @json_args[name.to_s]
    end
    
    def json_provided?
      !ENV[JSON_PAYLOAD_KEY].nil?
    end

    def serialize(value)
      value = ArraySerializer.new(value) if value.is_a?(Array)
      value.to_s
    end
  end
end