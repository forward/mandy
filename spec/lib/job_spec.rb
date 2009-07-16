require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mandy::Job do
  describe "store" do
    it "allows configuring a store" do
      Mandy.stores.clear
      job = Mandy::Job.new("test1") { store(:hbase, :test_store, :url => 'http://abc.com/test') }
      Mandy.stores.should == { :test_store => Mandy::Stores::HBase.new(:url => 'http://abc.com/test') }
    end
  end
end