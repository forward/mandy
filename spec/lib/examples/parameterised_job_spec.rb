require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
ENV['MANDY_PATH'] = File.join(File.dirname(__FILE__), *%w[.. .. .. lib mandy.rb])

ENV["prefix"] = 'Test'

Mandy.job "#{Mandy.parameter(:prefix)} Parameterised job" do
  map do |key, value|
    emit(key, "#{parameter(:argument)} #{parameter(:name)}")
  end
end

describe "Parameterised example" do
  before(:all) do
    ENV["json"] = nil
    ENV['name'] = 'Andy'
    @runner = Mandy::TestRunner.new("Test Parameterised job", :parameters => {:argument => "hello"})
  end
  
  after(:all) do
    Mandy::Job.jobs.delete_if { |job| job.name == "Test Parameterised job"}
  end
  
  describe "Mapper" do
    it "should emit parameter as value" do
      @runner.map("key\tvalue") do |mapper|
        mapper.should_receive(:emit).with("key", "hello Andy")
      end
    end
  end
end