require 'rubygems'
require "rake"
require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'mandy'))
require 'spec/rake/spectask'

task :default => :spec

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/lib/**/*_spec.rb']
  t.spec_opts = %w{-f s -c -L mtime}
end

task :gem do
  `sudo gem build mandy.gemspec`
  `mkdir pkg; mv mandy-*.gem pkg/`
  `sudo gem install pkg/mandy-*.gem`
end