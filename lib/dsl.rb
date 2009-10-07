module Mandy
  module DSL
    def job(name, &blk)
      raise "Mandy::DSL has been deprecated please use Mandy.job instead"
    end
  end
end