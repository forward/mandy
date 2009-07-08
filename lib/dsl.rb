module Mandy
  module DSL
    
    def self.included(klass)
      Mandy::Job.default = Mandy::Job.new('Untitled Job')
    end
    
    def map(&blk)
      Mandy::Job.default.map(&blk)
    end
    
    def reduce(&blk)
      Mandy::Job.default.reduce(&blk)
    end
  end
end