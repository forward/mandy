module Mandy
  module Reducers
    class SumReducer < Base
      def reducer(key,values)
        emit(key, values.inject(0) {|sum,count| sum+count.to_f})
      end
    end
  end
end
