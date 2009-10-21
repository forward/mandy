module Mandy
  module Serializers
    module Json
      def serialize_value(value)
        value.to_json
      end
      
      def deserialize_value(value)
        JSON.parse(value)
      end
    end
  end
end