module Mandy
  module Local
    module Wrapper
      SESSION_ID = Process.pid
  
      def run_mandy(script, input_files, options = {})
        begin
          #doing this will load all the mandy jobs in memory which will be useful later on
          require script

          input_file = concat_input_files(input_files)
          output_file_path = run_mandy_local(script, input_file, options)
          return output_file_path unless block_given?
          #if a block is given then yield the output file path and then delete this file before returning
          yield output_file_path
        ensure 
          File.delete(input_file) if File.exists?(input_file)
          File.delete(output_file_path) if output_file_path && File.exists?(output_file_path) if block_given?
        end
      end
  
      private
        def concat_input_files(inputs)
          inputs = [inputs] unless inputs.is_a?(Array)
          base_dir = File.dirname(inputs.first.path)
          input_file = "#{base_dir}/#{SESSION_ID}.csv"
          `cat #{inputs.collect{|f| f.path}.join(' ')} > #{input_file}`
          input_file
        end
    
        def run_mandy_local(script, input, options)
          mandy_job_params = options.include?(:parameters) ? options[:parameters] : {}
          param_args = "export json='#{mandy_job_params.to_json}' &&"
          
          if options.include?(:lib)
            FileUtils.cp(script, options[:lib])
            script = File.join(options[:lib], File.basename(script))
          end
          
          output_path = options[:output_file] || generate_output_path
          output_file = `#{param_args} mandy-local #{script} #{input} #{output_path}`
          output_file = output_file.split("\n").last
          output_file
        ensure
          File.delete(script) if options.include?(:lib)
        end
    
        def generate_output_path
          output_dir = "/tmp/mandy_local_output"
          FileUtils.mkdir_p(output_dir)
          file_name = Mandy::Job.jobs.last.name.downcase.gsub(/\W/, '-')
          "#{output_dir}/#{file_name}_#{DateTime.now.strftime('%Y%m%d%H%M%S')}"
        end
    end
  end
end

Object.send(:include, Mandy::Local::Wrapper)
