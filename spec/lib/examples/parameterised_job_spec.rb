require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
ENV['MANDY_PATH'] = File.join(File.dirname(__FILE__), *%w[.. .. .. lib mandy.rb])

include Mandy::DSL

job "Parameterised job" do
  map do |key, value|
    emit(key, parameter(:argument))
  end
end

describe "Parameterised example" do
  before(:all) do
    @runner = Mandy::TestRunner.new("Parameterised job", :parameters => {:argument => "hello world"})
  end
  
  describe "Mapper" do
    it "should emit parameter as value" do
      @runner.map("key\tvalue") do |mapper|
        mapper.should_receive(:emit).with("key", "hello world")
      end
    end
  end
end