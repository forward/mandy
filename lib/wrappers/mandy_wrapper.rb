module Mandy
  module Wrapper
    SESSION_ID = Process.pid
  
    def set_mandy_config(file_path)
      @@config_path = file_path
    end
  
    def run_mandy(script, inputs, options = {})
      begin
        #doing this will load all the mandy jobs in memory which will be useful later on
        require script
        inputs = [inputs] unless inputs.is_a?(Array)
        
        hdfs_input = inputs.all? {|i| i.is_a?(File)} ? process_files(inputs) : process_hdfs_locations(inputs)
        
        run_mandy_hadoop(hdfs_input, script, options)
        
        output_file_path = get_file_from_hdfs(hdfs_path, options)
        return output_file_path unless block_given?
        #if a block is given then yield the output file path and then delete this file before returning
        yield output_file_path
      ensure 
        File.delete(output_file_path) if output_file_path && File.exists?(output_file_path) if block_given?
      end
    end
  
    private
      def process_files(input_files)
        hdfs_path = "#{self.class.to_s.split('::').join('-').downcase}/#{SESSION_ID}"
        put_files_on_hdfs(hdfs_path, input_files)
        hdfs_path
      end
      
      def process_hdfs_locations(input_locations)
        return input_locations.first if input_locations.size == 1
        
        hdfs_path = "#{self.class.to_s.split('::').join('-').downcase}/#{SESSION_ID}"
        input_locations.each_with_index do |location, index|
          run_command "mandy-cp #{location} #{hdfs_path}/input#{index}"
        end
        hdfs_path
      end
    
      def put_files_on_hdfs(hdfs_path, input_files)
        input_files.each do |input_file|
          input_file_path = input_file.is_a?(File) ? File.expand_path(input_file.path) : input_file
          base_filename = input_file_path.split("/").last
          dest_file = ["input/#{hdfs_path}", base_filename].join("/")
          run_command "mandy-put #{input_file_path} #{dest_file}"
        end
      end
    
      def run_mandy_hadoop(hdfs_path, script, options)
        mandy_job_params = options.include?(:parameters) ? options[:parameters] : {}
        param_args = "-j '#{mandy_job_params.to_json}'"
        param_args += " -p '#{options[:lib]}'" if options.include?(:lib)

        hdfs_output_path = "output/#{hdfs_path}"
        run_command "mandy-rm output/#{hdfs_path}"
        run_command "mandy-hadoop #{script} input/#{hdfs_path} output/#{hdfs_path} #{param_args}"
      end
    
      def get_file_from_hdfs(hdfs_path, options)
        output_file_path = options[:output_file] || generate_output_path
        hdfs_output_path = "output/#{hdfs_path}"
        run_command "mandy-get #{get_hdfs_output(hdfs_output_path)} #{output_file_path}"
        run_command "mandy-rm input/#{hdfs_path}"
        run_command "mandy-rm output/#{hdfs_path}"
        output_file_path
      end
  
      def run_command(command)
        command = "#{command} -c #{@@config_path}"
        respond_to?(:logger) ? logger.info(command) : p(command)
        @output = `#{command}`
      end
    
      def generate_output_path
        output_dir = "/tmp/mandy_output"
        FileUtils.mkdir_p(output_dir)
        file_name = Mandy::Job.jobs.last.name.downcase.gsub(/\W/, '-')
        "#{output_dir}/#{file_name}_#{DateTime.now.strftime('%Y%m%d%H%M%S')}"
      end
      
      def get_hdfs_output(hdfs_output_path)
        @output.each_line do |line|
          return line.chomp.strip if line.include?(hdfs_output_path)
        end
      end
  end
end

Object.send(:include, Mandy::Wrapper)
