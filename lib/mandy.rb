%w(
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
  stores/hbase
  stores/in_memory
  test_runner
  ruby-hbase
).each {|file| require File.join(File.dirname(__FILE__), file) }

require "rubygems"
require "json"

module Mandy
  class << self
    def stores
      @stores||={}
    end
  end
end