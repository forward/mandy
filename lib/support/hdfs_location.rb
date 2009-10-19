module Mandy
  class HdfsLocation
    attr_reader :path
    
    def initialize(path)
      @path = path
    end
    
    def to_s
      @path
    end
  end
end