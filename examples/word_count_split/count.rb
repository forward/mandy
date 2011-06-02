# a job can consist of a map block, a reduce block or both along with some configuration options.
# this job counts words in the input document.
job "Word Count" do
  map_tasks 10
  reduce_tasks 3
  
  map do |key, value|
    value.split(' ').each do|word|
      word.downcase!
      emit(word, 1)
    end
  end

  reduce(Mandy::Reducers::SumReducer)
end