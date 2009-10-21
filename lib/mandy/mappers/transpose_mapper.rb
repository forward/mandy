module Mandy
  module Mappers
    class TransposeMapper < Base
      def mapper(key,value)
        # default map is simply a pass-through
        emit(value, key)
      end
    end
  end
end