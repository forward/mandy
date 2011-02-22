module Mandy
  class HadoopJobFailure < StandardError
    attr_reader :output
    
    def initialize(job, output)
      @job, @output = job, output
    end
    
    def job_name
      @job.name
    end
    
    def tracking_url
      line = @output.split("\n").find {|line| line =~ /Tracking URL/ }
      return nil unless line
      line.split('Tracking URL: ').last
    end
    
    def hadoop_error
      @output
    end
    
    def to_s
      output = []
      output << %(Mandy Job Name: #{job_name})
      output << %(Hadoop ERROR: #{hadoop_error})    
      output << %(Tracking URL: #{tracking_url}) if tracking_url
      output*"\n"
    end
  end
end