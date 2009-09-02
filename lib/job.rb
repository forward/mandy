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
      @modules = []
      @mapper_class = Mandy::Mappers::PassThroughMapper
      @reducer_class = Mandy::Reducers::PassThroughReducer
      set('mapred.job.name', name)
      instance_eval(&blk) if blk
    end
    
    def mixin(*modules)
      modules.each {|m| @modules << m}
    end
    alias_method :serialize, :mixin
    
    def input_format(format)
      @input_format = format
    end

    def output_format(format)
      @output_format = format
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
    
    def store(type, name, options={})
      Mandy.stores[name] = case type
      when :hbase
        Stores::HBase.new(options)
      else
        raise "Unknown store type #{type}"
      end
    end
    
    def map(klass=nil, &blk)
      @mapper_class = klass || Mandy::Mappers::Base.compile(&blk)
      @modules.each {|m| @mapper_class.send(:include, m) }
      @mapper_class
    end
    
    def reduce(klass=nil, &blk)
      @reducer_class = klass || Mandy::Reducers::Base.compile(&blk)
      @modules.each {|m| @reducer_class.send(:include, m) }
      @reducer_class
    end
    
    def run_map(input=STDIN, output=STDOUT, &blk)
      @mapper_class.send(:include, Mandy::IO::OutputFormatting) unless reducer_defined?
      mapper = @mapper_class.new(input, output, @input_format, @output_format)
      yield(mapper) if blk
      mapper.execute
    end
    
    def run_reduce(input=STDIN, output=STDOUT, &blk)
      reducer = @reducer_class.new(input, output, @input_format, @output_format)
      yield(reducer) if blk
      reducer.execute
    end
    
    private
    
    def reducer_defined?
      @reducer_class != Mandy::Reducers::PassThroughReducer
    end
    
  end
end