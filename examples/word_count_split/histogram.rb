# this job takes the output of the wordcount and draws a very simple histogram
job "Histogram" do
  map_tasks 5
  reduce_tasks 3
  
  RANGES = [0..1, 2..3, 4..5, 6..10, 11..20, 21..30, 31..40, 41..50, 51..100, 101..200, 201..300, 301..10_000, 10_001..99_999]
  map do |word, count|
    range = RANGES.find {|range| range.include?(count.to_i) }
    emit("#{range.first.to_s.rjust(5,'0')}-#{range.last.to_s.rjust(5,'0')}", 1)
  end
  
  reduce do |range, counts|
    total = counts.inject(0) {|sum,count| sum+count.to_i }
    emit(range, '|'*(total/20))
  end
end
