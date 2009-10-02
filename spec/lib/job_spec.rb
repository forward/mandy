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