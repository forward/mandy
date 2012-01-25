require "fileutils"

module Mandy
  class Packer
    TMP_DIR = '/tmp/mandy'
    MANDY_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
    
    def self.pack(script, dir, gemfile=nil)
      tmp_path = "#{TMP_DIR}/packed-job-#{Time.now.to_i}"
      FileUtils.mkdir_p(tmp_path)
      to_be_copied = File.file?(dir) ? dir : File.join(dir, '*')
      FileUtils.cp(script, tmp_path)
      FileUtils.cp(File.join(MANDY_DIR, 'VERSION'), tmp_path)
      FileUtils.cp_r(Dir.glob(to_be_copied), tmp_path)
      if gemfile and File.exists?(gemfile)
        FileUtils.cp(gemfile, File.join(tmp_path, 'geminstaller.yml')) 
      else
        FileUtils.cp(File.join(MANDY_DIR, 'geminstaller.yml'), tmp_path)
      end
      Dir.chdir(tmp_path) { `tar -cf bundle.tar *` }
      File.join(tmp_path, 'bundle.tar')
    end
    
    def self.cleanup!(file)
      return false unless File.extname(file) == '.tar'
      FileUtils.rm_r(File.dirname(file)) if File.exists?(File.dirname(file))
    end
  end
end