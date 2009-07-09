module Mandy
  module DSL
    def job(name, &blk)
      job = Mandy::Job.new(name)
      job.instance_eval(&blk) unless blk.nil?
      Mandy::Job.jobs << job
      job
    end
  end
end