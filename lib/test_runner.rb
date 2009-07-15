module Mandy
  class TestRunner
    attr_reader :job
    
    def initialize(job=Mandy::Job.jobs.first.name)
      @job = Mandy::Job.find_by_name(job)
    end
    
    def map(input_stream, output_stream=StringIO.new(''), &blk)
      input_stream = input_from_array(input_stream) if input_stream.is_a?(Array)
      input_stream = StringIO.new(input_stream.to_s) unless input_stream.is_a?(StringIO)
      @job.run_map(input_stream, output_stream, &blk)
      output_stream.rewind
      output_stream
    end
    
    def reduce(input_stream, output_stream=StringIO.new(''), &blk)
      input_stream = input_from_hash(input_stream) if input_stream.is_a?(Hash)
      input_stream = StringIO.new(input_stream.to_s) unless input_stream.is_a?(StringIO)
      @job.run_reduce(input_stream, output_stream, &blk)
      output_stream.rewind
      output_stream
    end
    
    def self.end_to_end(verbose=false)
      CompositeJobRunner.new(Mandy::Job.jobs,verbose)
    end
    
    private
    
    def input_from_array(input)
      input.join("\n")
    end
    
    def input_from_hash(input)
      output = []
      input.each do |key, values|
        output << "#{key}\t#{values}" and next unless values.is_a?(Array)
        values.each { |value| output << "#{key}\t#{value}" }
      end
      input_from_array(output.sort)
    end
    
    class CompositeJobRunner
      def initialize(jobs, verbose=false)
        @jobs = jobs
        @verbose = verbose
        @job_runners = @jobs.map { |job| Mandy::TestRunner.new(job.name) }
      end
      
      def execute(input_stream, output_stream=StringIO.new(''))
        map_temp = StringIO.new('')
        reduce_temp = StringIO.new('')
        @job_runners.each_with_index do |runner, index|
          runner.map(input_stream, map_temp)
          if @verbose
            puts "#{runner.job.name} [MAP] #{map_temp.readlines.inspect}"
            map_temp.rewind
          end
          reduce_input = StringIO.new(map_temp.readlines.sort.join(''))
          runner.reduce(reduce_input, (index==@job_runners.size-1 ? output_stream : reduce_temp))
          if @verbose
            puts "#{runner.job.name} [RED] #{reduce_temp.readlines.inspect}"
            reduce_temp.rewind
          end
          input_stream = reduce_temp
          map_temp = StringIO.new('')
          reduce_temp = StringIO.new('')
        end
        output_stream
      end
    end
  end
end