require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Mandy::Reducers::MaxReducer do  
  it "emits the maximum of all values for a given key" do
    reducer = Mandy::Reducers::MaxReducer.new(StringIO.new("key1\t1\nkey1\t2\nkey2\t10"), StringIO.new)
    reducer.should_receive(:emit).with('key1', 2)
    reducer.should_receive(:emit).with('key2', 10)
    reducer.execute
  end  
end