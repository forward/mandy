require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Mandy::Mappers::PassThroughMapper do
  before(:each) do
    @input, @output = StringIO.new("key1\tvalue1\nkey2, value2"), StringIO.new
    @mapper = Mandy::Mappers::PassThroughMapper.new(@input, @output)
  end
  
  it "calls .map(key, value) once for each line in the input" do
    @mapper.should_receive(:mapper).twice
    @mapper.execute
  end
  
  it "calls .map(key, value) with correct values" do
    @mapper.should_receive(:mapper).with('key1', 'value1')
    @mapper.should_receive(:mapper).with('key2, value2')
    @mapper.execute
  end
  
  it "outputs a key value pair when .emit(key, value) is called" do
    @output.should_receive(:puts).with("key1\tvalue1")
    @output.should_receive(:puts).with("key2, value2")
    @mapper.execute
  end
  
  it "allows compiling with a different map function" do
    mapper = Mandy::Mappers::PassThroughMapper.compile { |k,v| emit('a', 1) }
    map = mapper.new(StringIO.new("k\tv"), StringIO.new(''))
    map.should_receive(:emit).with('a', 1)
    map.execute
  end
  
  it "serializes array values" do
    mapper = Mandy::Mappers::PassThroughMapper.compile { |k,v| emit('a', [1,2,3]) }
    output = StringIO.new('')
    map = mapper.new(StringIO.new("k\tv"), output)
    output.should_receive(:puts).with("a\t1|2|3")
    map.execute
  end
  
  it "can read/write to stores" do
    store = mock('store')
    store.should_receive(:get).with("a")
    store.should_receive(:put).with("a", 'b'=>'c')
    Mandy::stores[:test] = store
    mapper = Mandy::Mappers::PassThroughMapper.compile do |k,v| 
      put(:test, "a", 'b'=>'c')
      get(:test, 'a')
    end
    mapper.new(StringIO.new("1\n"), StringIO.new).execute
  end
end