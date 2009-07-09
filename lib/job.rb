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
      @mapper_class = Mandy::Mappers::PassThroughMapper
      @reducer_class = Mandy::Reducers::PassThroughReducer
      set('mapred.job.name', name)
      instance_eval(&blk) if blk
    end
    
    def set(key, value)
      @settings[key.to_s] = value.to_s
    end
    
    def map_tasks(count)
      set('mapred.map.tasks', count)
    end
    
    def reduce_tasks(count)
      set('mapred.reduce.tasks', count)
    end
    
    def map(klass=nil, &blk)
      @mapper_class = klass || Mandy::Mappers::Base.compile(&blk)
    end
    
    def reduce(klass=nil, &blk)
      @reducer_class = klass || Mandy::Reducers::Base.compile(&blk)
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