module Mandy
  class Job
    class << self
      attr_accessor :default
    end
    
    attr_reader :settings
    
    def initialize(name, &blk)
      @name = name
      @settings = {}
      instance_eval(&blk) if blk
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