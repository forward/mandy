require 'rubygems'
require "rake"
require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'mandy'))
# require 'spec/rake/spectask'
# 
# task :default => :spec

# Spec::Rake::SpecTask.new(:spec) do |t|
#   t.spec_files = FileList['spec/lib/**/*_spec.rb']
#   t.spec_opts = %w{-f s -c -L mtime}
# end

namespace :gem do
  task :build do
    `gem build mandy.gemspec`
    `mkdir pkg; mv mandy-*.gem pkg/`
  end

  task :install => :build do
    `gem install pkg/mandy-*.gem --no-rdoc --no-ri`
  end
  
  task :push => :build do
    `gem push pkg/mandy-#{File.read(File.join(File.dirname(__FILE__), 'VERSION'))}.gem`
  end
end