Mandy.job "Count values in sequence file" do
  map_tasks 5
  reduce_tasks 1
  
  map do |key, value|
    value.split("\t").each {|word| emit(word, 1)}
  end
  
  reduce(Mandy::Reducers::SumReducer)
end
