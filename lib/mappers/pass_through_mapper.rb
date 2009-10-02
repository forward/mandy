module Mandy
  module Mappers
    class PassThroughMapper < Base
      def mapper(*params)
        # default map is simply a pass-through
        params.size == 1 ? emit(params[0]) : emit(params[0], params[1])
      end
    end
  end
end