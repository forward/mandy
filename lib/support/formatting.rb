module Mandy
  module IO
    module Formatting
      def input_deserialize_key(key)
        return key if input_format && input_format == :plain
        deserialize_key(key)
      end
      
      def input_deserialize_value(value)
        return value if input_format && input_format == :plain
        deserialize_value(value)
      end
      
      def output_serialize_key(key)
        return key if output_format && output_format == :plain
        deserialize_key(key)
      end
      
      def output_serialize_value(value)
        return value if output_format && output_format == :plain
        deserialize_value(value)
      end
      
    end
  end
end
