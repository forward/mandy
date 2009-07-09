module Mandy
  class Job
    class << self
      def jobs
        @jobs ||= []
      end
      
      def find_by_name(name)
        jobs.find {|job| job.name == name }
      end
    end
    
    attr_reader :settings
    attr_reader :name
    
    def initialize(name, &blk)
      @name = name
      @settings = {}
      @mapper_class = Mandy::Mapper
      @reducer_class = Mandy::Reducer
      set('mapred.job.name', name)
      instance_eval(&blk) if blk
    end
    
    def set(key, value)
      @settings[key.to_s] = value.to_s
    end
    
    def map(&blk)
      @mapper_class = Mandy::Mapper.compile(&blk)
    end
    
    def reduce(&blk)
      @reducer_class = Mandy::Reducer.compile(&blk)
    end
    
    def run_map(input=STDIN, output=STDOUT, &blk)
      mapper = @mapper_class.new(input, output)
      yield(mapper) if blk
      mapper.execute
    end
    
    def run_reduce(input=STDIN, output=STDOUT, &blk)
      reducer = @reducer_class.new(input, output)
      yield(reducer) if blk
      reducer.execute
    end
  end
end