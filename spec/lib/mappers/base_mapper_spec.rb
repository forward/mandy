require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Mandy::Mappers::Base do
  it "should provide single parameter when no tab separated input" do
    input, output = StringIO.new("key, value"), StringIO.new
    mapper = Mandy::Mappers::Base.compile {|value| emit('found', value)}
    
    mapper.new(input, output).execute

    output.rewind
    output.read.should == "found\tkey, value\n"
  end
  
  it "should provide two parameters when a tab separated input" do
    input, output = StringIO.new("key\tvalue"), StringIO.new
    mapper = Mandy::Mappers::Base.compile {|k,v| emit(k, v)}
        
    mapper.new(input, output).execute
    
    output.rewind
    output.read.should == "key\tvalue\n"
  end
  
end