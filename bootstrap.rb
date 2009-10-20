require "fileutils"

module Mandy
  class Packer
    def self.unpack(file)
      return false unless File.extname(file) == '.tar'
      `tar -xf #{file}`
      `geminstaller --sudo --silent --exceptions`
    end
  end
end

Mandy::Packer.unpack(ARGV[0])

exec("mandy-#{ARGV[1]} #{ARGV[2]} '#{ARGV[3]}'")