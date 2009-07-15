require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mandy::Tuple do
  it "has a name and a value" do
    tuple = Mandy::Tuple.new('name', 'value')
    tuple.name.should == 'name'
    tuple.value.should == 'value'
  end
  
  it "serialises to a string" do
    tuple = Mandy::Tuple.new('name', 'value')
    tuple.to_s.should == 'name,value'
  end
  
  it "de-serialises from a string" do
    tuple = Mandy::Tuple.from_s('name,value')
    tuple.name.should == 'name'
    tuple.value.should == 'value'
  end
  
  it "is equal when it has the same names and values" do
    tuple1 = Mandy::Tuple.new('name', 'value')
    tuple2 = Mandy::Tuple.new('name', 'value')
    tuple3 = Mandy::Tuple.new('name', 'value2')
    tuple1.should == tuple2
    tuple2.should_not == tuple3
  end
  
  it "allows setting different accessor methods" do
    tuple = Mandy::Tuple.new('a', 'b', :a, :b)
    tuple.a.should == 'a'
    tuple.b = 'b1'
    tuple.b.should == 'b1'
  end
end