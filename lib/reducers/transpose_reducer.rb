module Mandy
  module Reducers
    class TransposeReducer < Base
      def reducer(key,values)
        values.each {|value| emit(value, key) }
      end
    end
  end
end
