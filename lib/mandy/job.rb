module Mandy
  class Job
    JSON_PAYLOAD_KEY = "json"
    
    class << self
      def jobs
        @jobs ||= []
      end
      
      def find_by_name(name)
        jobs.find {|job| job.name == name }
      end
      
      def parameter(name)
        param = find_json_param(name) if json_provided?
        param || ENV[name.to_s]
      end

      private

      def find_json_param(name)
        json_args = JSON.parse(CGI.unescape(ENV[JSON_PAYLOAD_KEY]))
        json_args[name.to_s]
      end

      def json_provided?
        !ENV[JSON_PAYLOAD_KEY].nil?
      end
    end
    
    attr_reader :settings
    attr_reader :name
    attr_reader :input_format_options

    def initialize(name, &blk)
      @name = name
      @settings = {}
      @modules = []
      @map, @reduce = nil, nil
      set('mapred.job.name', name)
      instance_eval(&blk) if blk
      auto_set_reduce_count
    end
    
    def mixin(*modules)
      modules.each {|m| @modules << m}
    end
    alias_method :serialize, :mixin

    def input_format(format=nil, options={})
      return @input_format if format.nil?
      
      @input_format = format
      @input_format_options = options
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
    
    def setup(&blk)
      @setup = blk
    end
    
    def teardown(&blk)
      @teardown = blk
    end
    
    def map(klass=nil, &blk)
      @map = klass || blk
    end
    
    def reduce(klass=nil, &blk)
      @reduce = klass || blk
    end
    
    def run_map(input=STDIN, output=STDOUT, &blk)
      mapper_class.send(:include, Mandy::IO::OutputFormatting) unless reducer_defined?
      mapper = mapper_class.new(input, output, @input_format, @output_format)
      yield(mapper) if blk
      mapper.execute
    end
    
    def run_reduce(input=STDIN, output=STDOUT, &blk)
      reducer = reducer_class.new(input, output, @input_format, @output_format)
      yield(reducer) if blk
      reducer.execute
    end
    
    def reducer_defined?
      !@reduce.nil?
    end
    
    private
    
    def auto_set_reduce_count
      return if settings.has_key?('mapred.reduce.tasks')
      reduce_tasks(reducer_defined? ? 1 : 0)
    end

    def mapper_class
      return Mandy::Mappers::PassThroughMapper unless @map
      @mapper_class ||= compile_map
    end
    
    def reducer_class
      return Mandy::Reducers::PassThroughReducer unless @reduce
      @reducer_class ||= compile_reduce
    end
    
    def compile_map
      args = {}
      args[:setup] = @setup if @setup
      args[:teardown] = @teardown if @teardown
      @mapper_class = @map.is_a?(Proc) ? Mandy::Mappers::Base.compile(args, &@map) : @map
      @modules.each {|m| @mapper_class.send(:include, m) }
      @mapper_class
    end
    
    def compile_reduce
      args = {}
      args[:setup] = @setup if @setup
      args[:teardown] = @teardown if @teardown
      @reducer_class = @reduce.is_a?(Proc) ? Mandy::Reducers::Base.compile(args, &@reduce) : @reduce
      @modules.each {|m| @reducer_class.send(:include, m) }
      @reducer_class
    end
    
  end
end