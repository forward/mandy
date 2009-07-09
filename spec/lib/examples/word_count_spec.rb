require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
ENV['MANDY_PATH'] = File.join(File.dirname(__FILE__), *%w[.. .. .. lib mandy.rb])
require File.join(File.dirname(__FILE__), *%w[.. .. .. examples word_count])

describe "Word count example" do
  before(:all) do
    @word_count_runner = Mandy::TestRunner.new("Word Count")
  end
  
  describe "mapper" do
    it "converts input lines and emits word/count pairs" do
      @word_count_runner.map("hello andy andy\nhello paul") do |mapper|
        mapper.should_receive(:emit).with('hello', 1).twice
        mapper.should_receive(:emit).with('andy', 2)
        mapper.should_receive(:emit).with('paul', 1)
      end
    end
    
    it "as above but with array input" do
      @word_count_runner.map(["hello andy andy", "hello paul"]) do |mapper|
        mapper.should_receive(:emit).with('hello', 1).twice
        mapper.should_receive(:emit).with('andy', 2)
        mapper.should_receive(:emit).with('paul', 1)
      end
    end
    
    it "outputs correctly formatted key/value pairs (just a test to play with the test runner really)" do
      @word_count_runner.map("hello andy andy\nhello paul").readlines.should == [
        "andy\t2\n",
        "hello\t1\n",
        "paul\t1\n",
        "hello\t1\n"
      ]
    end
    
    it "downcases words" do
      @word_count_runner.map("Andy andy") do |mapper|
        mapper.should_receive(:emit).with('andy', 2)
      end
    end
    
    it "removes punctuation at start and end of words" do
      @word_count_runner.map("a. 'b c'd") do |mapper|
        mapper.should_receive(:emit).with('a',1)
        mapper.should_receive(:emit).with('b',1)
        mapper.should_receive(:emit).with("c'd",1)
      end
    end
  end
  
  describe "reducer" do
    it "sums up counts and emits them" do
      @word_count_runner.reduce("andy\t200\nhello\t10\nhello\t100\npaul\t1") do |reducer|
        reducer.should_receive(:emit).with('andy', 200)
        reducer.should_receive(:emit).with('hello', 110)
        reducer.should_receive(:emit).with('paul', 1)
      end
    end
    
    it "as above but with a hash input" do
      @word_count_runner.reduce('andy' => '200', 'hello' => ['10','100'], 'paul' => '1') do |reducer|
        reducer.should_receive(:emit).with('andy', 200)
        reducer.should_receive(:emit).with('hello', 110)
        reducer.should_receive(:emit).with('paul', 1)
      end
    end
  end
end