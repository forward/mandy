# normally just requiring mandy through gems is fine.
# we try and load a local version first in this example so that our specs don't use gem files.
if ENV['MANDY_PATH']
  require ENV['MANDY_PATH']
else
  require "rubygems"
  require "mandy"
end

# including Mandy::DSL adds the block methods used below to the global namespace, it's highly recommended.
include Mandy::DSL

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
      next unless word.any?
      words[word] ||= 0 
      words[word] += 1
    end
    words.each {|word, count| emit(word, count) }
  end

  reduce(Mandy::Reducers::SumReducer)
end