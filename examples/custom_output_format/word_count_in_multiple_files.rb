require "rubygems"
require "mandy"

# a job can consist of a map block, a reduce block or both along with some configuration options.
# this job counts words in the input document.
Mandy.job "Word Count" do
  map_tasks 5
  reduce_tasks 3
  
  map do |*values|
    value = values.join(' ')
    words = {}
    
    update_status("Processing line: #{value}")
    
    value.split(' ').each do |word|
      word.downcase!
      word.gsub!(/\W|[0-9]/, '')
      next if word.size == 0
      words[word] ||= 0 
      words[word] += 1
      
      increment_counter("Word counting", "No. of words processed", 1)
    end
    words.each {|word, count| emit(word, count) }
  end
  
  reduce do |word, values|
    sum_of_count = values.inject(0) do |sum, value|
      sum += value.to_i
      sum
    end
    file_name = word.upcase.split(//).first
    emit(Mandy::Tuple.new(file_name, word), sum_of_count)
  end
end