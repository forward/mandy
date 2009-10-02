require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Mandy::Mappers::Base do
  it "should provide single parameter when no tab separated input" do
    input, output = StringIO.new("key, value"), StringIO.new
    
    mapper = Mandy::Mappers::Base.compile do |v|
      v.should == "key, value"
    end
    
    mapper.new(input, output).execute
  end
  
  it "should provide two parameters when a tab separated input" do
    input, output = StringIO.new("key\tvalue"), StringIO.new
    
    mapper = Mandy::Mappers::Base.compile do |k,v|
      k.should == "key"
      v.should == "value"
    end
    
    mapper.new(input, output).execute
  end
  
end