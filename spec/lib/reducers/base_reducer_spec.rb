require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Mandy::Reducers::Base do  
  it "should allow access to environment variables" do
    ENV["variable_test"] = "hello world"
    Mandy::Reducers::Base.new.send(:parameter, :variable_test).should == "hello world"
  end
end