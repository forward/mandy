%w(
  support/tuple 
  support/array_serializer 
  mappers/base_mapper 
  mappers/pass_through_mapper 
  reducers/base_reducer 
  reducers/pass_through_reducer 
  reducers/sum_reducer 
  reducers/max_reducer 
  reducers/min_reducer 
  dsl 
  job 
  test_runner
).each {|file| require File.join(File.dirname(__FILE__), file) }