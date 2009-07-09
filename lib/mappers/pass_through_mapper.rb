module Mandy
  module Mappers
    class PassThroughMapper < Base
      def mapper(key,value)
        # default map is simply a pass-through
        emit(key, value)
      end
    end
  end
end