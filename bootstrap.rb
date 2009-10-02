require "fileutils"

module Mandy
  class Packer
    TMP_DIR = '/tmp/mandy'
    
    def self.pack(dir)
      return dir if File.file?(dir)
      FileUtils.mkdir_p(TMP_DIR)
      tmp_path = "#{TMP_DIR}/packed-job-#{Time.now.to_i}.tar"
      Dir.chdir(dir) { `tar -cf #{tmp_path} *` }
      tmp_path
    end
    
    def self.unpack(file)
      return false unless File.extname(file) == '.tar'
      `tar -xf #{file}`
    end
    
    def self.cleanup!(file)
      return false unless File.extname(file) == '.tar'
      `rm #{file}`
    end
  end
end

Mandy::Packer.unpack(ARGV[0])

`bin/mandy-#{ARGV[1]} #{ARGV[2]} '#{ARGV[3]}'`