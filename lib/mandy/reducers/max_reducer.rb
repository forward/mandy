module Mandy
  module Reducers
    class MaxReducer < Base
      def reducer(key,values)
        values.map! {|value| value.to_f}
        emit(key, values.max)
      end
    end
  end
end
