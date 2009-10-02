require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mandy::Task do
  describe "job parameters" do
    it "should allow access to environment variables" do
      ENV["variable_test"] = "hello world"
      Mandy::Task.new.send(:parameter, :variable_test).should == "hello world"
    end

    it "should parse json encoded parameters" do
      ENV["json"] = '{"meaning_of_life":"42"}'
      Mandy::Task.new.send(:parameter, :meaning_of_life).should == "42"
    end

    it "should parse uri encoded json parameters" do
      ENV["json"] = '%7B%22meaning_of_life%22:%2242%22%7D'
      Mandy::Task.new.send(:parameter, :meaning_of_life).should == "42"
    end
  end
  
  describe "serialisation" do
    it "should convert numeric key to 16-digit padded string" do
      input = ""
      output = StringIO.new('')
      Mandy::Task.new(input, output).emit(10, "")
      
      output.rewind
      output.read.chomp.should == "0000000000000010\t"
    end
    
    it "should pad floating point key" do
      input = ""
      output = StringIO.new('')
      Mandy::Task.new(input, output).emit(10.5, "")
      
      output.rewind
      output.read.chomp.should == "0000000000000010.5\t"
    end

    it "should not pad key more than 16 digits" do
      input = ""
      output = StringIO.new('')
      Mandy::Task.new(input, output).emit(99999999999999999, "")
      
      output.rewind
      output.read.chomp.should == "99999999999999999\t"
    end
  end
  
  describe "status updates" do
    it "writes reporter status message to STDERR" do
      input = ""
      output = StringIO.new('')
      
      STDERR.should_receive(:puts).with("reporter:status:this is the status")
      Mandy::Task.new(input, output).send(:update_status, "this is the status")
    end
  end
end