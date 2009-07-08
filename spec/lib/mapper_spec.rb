require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mandy::Mapper do
  before(:each) do
    @input, @output = StringIO.new("key1\tvalue1\nkey2, value2"), StringIO.new
    @mapper = Mandy::Mapper.new(@input, @output)
  end
  
  it "calls .map(key, value) once for each line in the input" do
    @mapper.should_receive(:mapper).twice
    @mapper.execute
  end
  
  it "calls .map(key, value) with correct values" do
    @mapper.should_receive(:mapper).with('key1', 'value1')
    @mapper.should_receive(:mapper).with(nil, 'key2, value2')
    @mapper.execute
  end
  
  it "outputs a key value pair when .emit(key, value) is called" do
    @output.should_receive(:puts).with("key1\tvalue1")
    @output.should_receive(:puts).with("nil\tkey2, value2")
    @mapper.execute
  end
  
  it "allows compiling with a different map function" do
    mapper = Mandy::Mapper.compile { |k,v| emit('a', 1) }
    map = mapper.new(StringIO.new("k\tv"), StringIO.new(''))
    map.should_receive(:emit).with('a', 1)
    map.execute
  end
end