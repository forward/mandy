require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Mandy::Reducers::SumReducer do  
  it "emits the sum of all values for a given key" do
    reducer = Mandy::Reducers::SumReducer.new(StringIO.new("key1\t1\nkey1\t2\nkey2\t10"), StringIO.new)
    reducer.should_receive(:emit).with('key1', 3)
    reducer.should_receive(:emit).with('key2', 10)
    reducer.execute
  end  
  
  it "works with floating point numbers too" do
    reducer = Mandy::Reducers::SumReducer.new(StringIO.new("key1\t1.2\nkey1\t3.3"), StringIO.new)
    reducer.should_receive(:emit).with('key1', 4.5)
    reducer.execute
  end
end