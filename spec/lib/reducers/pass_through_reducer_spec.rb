require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Mandy::Reducers::PassThroughReducer do
  before(:each) do
    @input, @output = StringIO.new("key1\tvalue1\nkey1\tvalue2"), StringIO.new
    @reducer = Mandy::Reducers::PassThroughReducer.new(@input, @output)
  end
  
  it "calls .reducer(key, value) once for each line in the input" do
    @reducer.should_receive(:reducer).once
    @reducer.execute
  end
  
  it "calls .reducer(key, value) with correct values" do
    @reducer.should_receive(:reducer).with('key1', ['value1', 'value2'])
    @reducer.execute
  end
  
  it "outputs a key value pair when .emit(key, value) is called" do
    @output.should_receive(:puts).with("key1\tvalue1")
    @output.should_receive(:puts).with("key1\tvalue2")
    @reducer.execute
  end
  
  
  it "serializes array values" do
    reducer = Mandy::Reducers::PassThroughReducer.compile { |k,v| emit('a', [1,2,3]) }
    output = StringIO.new('')
    reduce = reducer.new(StringIO.new("k\tv"), output)
    output.should_receive(:puts).with("a\t1|2|3")
    reduce.execute
  end
end