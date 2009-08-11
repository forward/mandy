require "fileutils"

module Mandy
  class Packer
    TMP_DIR = '/tmp/mandy'
    
    def self.pack(dir)
      return dir if File.file?(dir)
      FileUtils.mkdir_p(TMP_DIR)
      tmp_path = "#{TMP_DIR}/packed-job-#{Time.now.to_i}.tar"
      `tar -cf #{tmp_path} #{dir}`
      tmp_path
    end
    
    def self.unpack(file)
      return false unless File.extname(payload) == '.tar'
      `tar -xf --overwrite #{file}`
    end
  end
end