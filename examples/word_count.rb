require "rubygems"
require "mandy"

include Mandy::DSL

job "Word Count" do
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
    emit(key, total) if key.any?
  end
end

job "Histogram" do
  RANGES = [0..5, 6..10, 11..20, 21..30, 31..40, 41..50, 51..100, 101..200, 201..300, 301..10_000]
  
  map do |word, count|
    range = RANGES.find {|range| range.include?(count.to_i) }
    emit("#{range.first.to_s.rjust(5,'0')}-#{range.last.to_s.rjust(5,'0')}", 1)
  end
  
  reduce do |range, counts|
    total = counts.inject(0) {|sum,count| sum+count.to_i }
    emit(range, '|'*(total/10).ceil)
  end
end

job "Sort"