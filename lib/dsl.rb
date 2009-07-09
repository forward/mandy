module Mandy
  module DSL
    
    def self.included(klass)
      Mandy::Job.default = Mandy::Job.new('Untitled Job')
    end
    
    def set(key, value)
      Mandy::Job.default.settings[key.to_s] = value
    end
    
    def job_name(name)
      set "mapred.job.name", name.to_s
    end
    
    def map(&blk)
      Mandy::Job.default.map(&blk)
    end
    
    def reduce(&blk)
      Mandy::Job.default.reduce(&blk)
    end
  end
end