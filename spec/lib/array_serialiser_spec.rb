require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mandy::ArraySerializer do
  it "serialises arrays to strings" do
    Mandy::ArraySerializer.new([1,2,3]).to_s.should == "1|2|3"
  end
  
  it "serialises tuples" do
    tuple = Mandy::Tuple.new('k','v')
    Mandy::ArraySerializer.new([tuple, tuple]).to_s.should == "k,v|k,v"    
  end
  
  it "de-serialises strings to arrays" do
    Mandy::ArraySerializer.from_s('1|2|3').should == ['1','2','3']
  end
  
  it "de-serialises tuple strings to arrays" do
    tuple = Mandy::Tuple.new('k','v')
    Mandy::ArraySerializer.tuples_from_s('k,v|k,v').should == [tuple, tuple]
  end
end