module Mandy
  class TestRunner
    def initialize(job=Mandy::Job.default)
      @job = job
    end
    
    def map(input, output_stream=StringIO.new(''), &blk)
      input = input_from_array(input) if input.is_a?(Array)
      input_stream = StringIO.new(input.to_s)
      @job.run_map(input_stream, output_stream, &blk)
      output_stream.rewind
      output_stream
    end
    
    def reduce(input, output_stream=StringIO.new(''), &blk)
      input = input_from_hash(input) if input.is_a?(Hash)
      input_stream = StringIO.new(input.to_s)
      @job.run_reduce(input_stream, output_stream, &blk)
      output_stream.rewind
      output_stream
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
  end
end