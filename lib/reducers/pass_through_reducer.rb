module Mandy
  module Reducers
    class PassThroughReducer < Base
      def reducer(key,values)
        values.each {|value| emit(key, value) }
      end
    end
  end
end
