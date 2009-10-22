require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module TestModule
  def dragon
    "trogdor"
  end
end

describe Mandy::Job do
  
  describe "map only jobs" do
    it "should allow map only jobs to run" do
      input, output = StringIO.new("carl\nandy"), StringIO.new("")
      job = Mandy::Job.new("test1") do
        map do |name|
          emit("hello #{name}")
        end
      end

      job.run_map(input, output)

      output.rewind
      output.read.should == "hello carl\nhello andy\n"
    end  
    
    it "should set reducers to 0 if none is provided" do
      job = Mandy::Job.new("test1") do
        map {}
      end
      job.settings['mapred.reduce.tasks'].should == '0'
    end  
    
    it "should set reducers to 1 if it is provided" do
      job = Mandy::Job.new("test1") do
        map {}
        reduce {}
      end
      job.settings['mapred.reduce.tasks'].should == '1'
    end  

    it "should not override reduce_tasks if it is set" do
      job = Mandy::Job.new("test1") do
        reduce_tasks 3
        map {}
      end
      job.settings['mapred.reduce.tasks'].should == '3'
    end
  end
  
  describe "Setup" do
    it "allows maps to have setup blocks run before tasks execute" do
      input, output = StringIO.new("testing"), StringIO.new("")
      job = Mandy::Job.new("test1") do
        setup do
          @setup = "fake carl"
          @reduce_setup = 'real carl'
        end
        
        map do |k,v|
          emit("hello", @setup)
        end
      end
      
      job.run_map(input, output)
      
      output.rewind
      output.read.chomp.should == "hello\tfake carl"
    end
    
    it "allows maps to have teardown blocks run after tasks execute" do
      SomeService = Class.new
      SomeService.should_receive(:teardown!).once
      
      input, output = StringIO.new("testing"), StringIO.new("")
      job = Mandy::Job.new("test1") do
        map do |k,v|
          emit("hello", @setup)
        end

        teardown { SomeService.teardown! }
      end
      
      job.run_map(input, output)
    end

    it "allows reduces to have setup blocks run before tasks execute" do
      input, output = StringIO.new("testing\t123"), StringIO.new("")
      job = Mandy::Job.new("test1") do
        setup do
          @setup = "fake carl"
        end
        
        reduce do |k,v|
          emit("hello", @setup)
        end
      end
      
      job.run_reduce(input, output)
      
      output.rewind
      output.read.chomp.should == "hello\tfake carl"
    end
    
    it "allows reduces to have teardown blocks run after tasks execute" do
      SomeService = Class.new
      SomeService.should_receive(:teardown!).once
      
      input, output = StringIO.new("testing\t123"), StringIO.new("")
      job = Mandy::Job.new("test1") do
        teardown do
          SomeService.teardown!
        end
        
        reduce do |k,v|
          emit("hello", @setup)
        end
      end
      
      job.run_reduce(input, output)
    end
    
    it "adds setup block to class maps" do
      class SomeMapper < Mandy::Mappers::Base
        def setup
          @something = "real carl"
        end

        def mapper(*args)
          emit('hello', @something)
        end
      end
      
      input, output = StringIO.new("testing\t123"), StringIO.new("")
      job = Mandy::Job.new("test1") do
        map(SomeMapper)
      end
      
      job.run_map(input, output)
      
      output.rewind
      output.read.chomp.should == "hello\treal carl"
    end
  end
  
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
    
  describe "custom serialisation" do
    it "should allow for standard input format" do
      input = "manilow\t1978,lola"
      map_output, reduce_output = StringIO.new(''), StringIO.new('')
      job = Mandy::Job.new("lola") do
        serialize Mandy::Serializers::Json
        input_format :plain
        output_format :plain

        map do|k,v|
          emit(k, {"year" => "1978", "name" => "lola"})
        end
        
        reduce do |k, values|
          v = values.first
          emit(k, v["year"] + "," + v["name"])
        end
      end
      
      job.run_map(input, map_output)
      map_output.rewind
      job.run_reduce(map_output, reduce_output)
      
      reduce_output.rewind
      reduce_output.read.chomp.should == input
    end
    
    it "should use standard output when job has no reducers" do
      input = "manilow\t1978,lola"
      output = StringIO.new('')
      job = Mandy::Job.new("lola") do
        serialize Mandy::Serializers::Json
        input_format :plain
        output_format :plain

        map do|k,v|
          emit(k, v)
        end        
      end
      
      job.run_map(input, output)
      
      output.rewind
      output.read.chomp.should == input
    end
    
    it "should allow output to be converted to json from plaintext input" do
      input = "manilow\t1978,lola"
      output = StringIO.new('')
      job = Mandy::Job.new("lola") do
        serialize Mandy::Serializers::Json
        input_format :plain
        output_format :pants

        map do|k,v|
          emit(k, v.split(","))
        end        
      end
      
      job.run_map(input, output)
      
      output.rewind
      output.read.chomp.should == "manilow\t[\"1978\",\"lola\"]"
    end
    
    it "should allow serialisation module to be mixed in" do
      input = to_input_line("manilow", {:dates => [1, 9, 7, 8], :name => "lola"})
      output = StringIO.new('')
      job = Mandy::Job.new("lola") do
        serialize Mandy::Serializers::Json

        map do|k,v|
          k.should == "manilow"
          v.should == {"dates" => [1, 9, 7, 8], "name" => "lola"}
          emit(k, v)
        end
      end
      
      job.run_map(input, output)
      
      output.rewind
      output.read.chomp.should == "manilow\t{\"name\":\"lola\",\"dates\":[1,9,7,8]}"
    end
    
    def to_input_line(k,v)
      [k, v.to_json].join("\t")
    end
  end
  
end