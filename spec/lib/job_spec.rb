require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module TestModule
  def dragon
    "trogdor"
  end
end

describe Mandy::Job do
  describe "store" do
    it "allows configuring a store" do
      Mandy.stores.clear
      job = Mandy::Job.new("test1") { store(:hbase, :test_store, :url => 'http://abc.com/test') }
      Mandy.stores.should == { :test_store => Mandy::Stores::HBase.new(:url => 'http://abc.com/test') }
    end
  end
  
  describe "mixins" do
    it "should mixin module to mapper" do
      input, output = StringIO.new("something"), StringIO.new("")
      job = Mandy::Job.new("test1") { mixin TestModule; map do |k,v| emit(dragon) end; }

      job.run_map(input, output)
      
      output.rewind
      output.read.chomp.should == "trogdor"
    end

    it "should mixin module to reducer" do
      input, output = StringIO.new("something"), StringIO.new("")
      job = Mandy::Job.new("test1") { mixin TestModule; map do |k,v| end; reduce do |k,v| emit(dragon) end; }

      job.run_map(input, output)
      job.run_reduce(input, output)
      
      output.rewind
      output.read.chomp.should == "trogdor"
    end
  end
end