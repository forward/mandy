require 'rubygems'
require 'mandy'

Mandy.local_input = File.join(File.dirname(__FILE__), 'alice.txt1')

Mandy.job "Grep" do
  map_tasks 5

  map do |line|
    emit(line) if line =~ /Alice/
  end
end
