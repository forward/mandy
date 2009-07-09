require "rubygems"
require "mandy"

include Mandy::DSL

job_name "Word Count"

THRESHOLD = 100

map do |key, value|
  words = {}
  value.split(' ').each do|word|
    word.downcase!
    word.gsub!(/^\W|\W$/, '')
    words[word] ||= 0 
    words[word] += 1
  end
  words.each {|word, count| emit(word, count) }
end

reduce do |key, values|
  total = values.inject(0) {|sum,count| sum+count.to_i }
  emit(key, total) if total > THRESHOLD
end