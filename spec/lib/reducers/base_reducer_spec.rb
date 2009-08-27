require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Mandy::Reducers::Base do  
  it "should allow access to environment variables" do
    ENV["variable_test"] = "hello world"
    Mandy::Reducers::Base.new.send(:parameter, :variable_test).should == "hello world"
  end
  
  it "should parse json encoded parameters" do
    ENV["json"] = '{"meaning_of_life":"42"}'
    Mandy::Reducers::Base.new.send(:parameter, :meaning_of_life).should == "42"
  end
end