require "rubygems"
require "json"
require "uri"
require "cgi"

%w(
  support/formatting
  task
  dsl 
  job 
  packer
  support/tuple 
  support/array_serializer 
  mappers/base_mapper 
  mappers/transpose_mapper 
  mappers/pass_through_mapper 
  reducers/base_reducer 
  reducers/pass_through_reducer 
  reducers/sum_reducer 
  reducers/max_reducer 
  reducers/min_reducer
  reducers/transpose_reducer
  serializers/json
  stores/hbase
  stores/in_memory
  test_runner
  ruby-hbase
).each {|file| require File.join(File.dirname(__FILE__), file) }

module Mandy
  class << self
    attr_accessor :local_input
    def stores
      @stores||={}
    end
  end
  
  def job(name, &blk)
    job = Mandy::Job.new(name)
    job.instance_eval(&blk) unless blk.nil?
    Mandy::Job.jobs << job
    job
  end
  module_function :job
end

at_exit do
  raise $! if $!
  caller = Kernel.caller.first
  next if caller.nil?
  caller = caller.split(':').first
  next if caller =~ /bin\/(rake|mandy)/
  input = Mandy.local_input || ENV['MANDY_INPUT']
  unless input
    print "Input file: "
    input = gets.chomp
  end
  file  = caller
  output_folder = FileUtils.mkdir_p("/tmp/mandy-local")
  out = nil
  Mandy::Job.jobs.each_with_index do |job, i|
    out = File.join(output_folder, "#{i+1}-#{job.name.downcase.gsub(/\W/, '-')}")
    puts "Running #{job.name}..."
    `cat #{input} | mandy-map #{file} "#{job.name}" | sort | mandy-reduce #{file} "#{job.name}" > #{out}`
    input = out
  end

  puts File.read(out)
end