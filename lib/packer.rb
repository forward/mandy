require "fileutils"

module Mandy
  class Packer
    TMP_DIR = '/tmp/mandy'
    
    def self.pack(dir, gemfile)
      tmp_path = "#{TMP_DIR}/packed-job-#{Time.now.to_i}"
      FileUtils.mkdir_p(tmp_path)
      to_be_copied = File.file?(dir) ? dir : File.join(dir, '*')
      FileUtils.cp_r(Dir.glob(to_be_copied), tmp_path)
      FileUtils.cp_r(gemfile, tmp_path)
      Dir.chdir(tmp_path) { `gem bundle` }
      Dir.chdir(tmp_path) { `tar -cf bundle.tar *` }
      File.join(tmp_path, 'bundle.tar')
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