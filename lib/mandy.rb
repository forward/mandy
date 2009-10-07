require "rubygems"
require "json"
require "uri"
require "cgi"

%w(
  support/formatting
  task
  dsl 
  job 
  packer
  support/tuple 
  support/array_serializer 
  mappers/base_mapper 
  mappers/transpose_mapper 
  mappers/pass_through_mapper 
  reducers/base_reducer 
  reducers/pass_through_reducer 
  reducers/sum_reducer 
  reducers/max_reducer 
  reducers/min_reducer
  reducers/transpose_reducer
  serializers/json
  stores/hbase
  stores/in_memory
  test_runner
  ruby-hbase
).each {|file| require File.join(File.dirname(__FILE__), file) }

module Mandy
  class << self
    def stores
      @stores||={}
    end
  end
end