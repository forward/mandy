# a job can consist of a map block, a reduce block or both along with some configuration options.
# this job counts words in the input document.
job "Word Count" do
  map_tasks 5
  reduce_tasks 3
  
  map do |key, value|
    words = {}
    value.split(' ').each do|word|
      word.downcase!
      word.gsub!(/\W|[0-9]/, '')
      next if word.size == 0
      words[word] ||= 0 
      words[word] += 1
    end
    words.each {|word, count| emit(word, count) }
  end

  reduce(Mandy::Reducers::SumReducer)
end