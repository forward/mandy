require "fileutils"

module Mandy
  class Packer
    TMP_DIR = '/tmp/mandy'
    
    def self.pack(script, dir, gemfile)
      tmp_path = "#{TMP_DIR}/packed-job-#{Time.now.to_i}"
      FileUtils.mkdir_p(tmp_path)
      to_be_copied = File.file?(dir) ? dir : File.join(dir, '*')
      FileUtils.cp_r(script, tmp_path)
      FileUtils.cp_r(Dir.glob(to_be_copied), tmp_path)
      FileUtils.cp_r(gemfile, tmp_path)
      Dir.chdir(tmp_path) do 
        `gem bundle`
        `rm -r vendor/gems/gems`
        `tar -cf bundle.tar *`
      end
      File.join(tmp_path, 'bundle.tar')
    end
    
    def self.cleanup!(file)
      return false unless File.extname(file) == '.tar'
      `rm #{file}`
    end
  end
end