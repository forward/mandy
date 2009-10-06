require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Mandy::Packer do
  GEMFILE = File.join(File.dirname(__FILE__), "..", "..", "..", "Gemfile")
  
  def package_script(script)
    Mandy::Packer.pack(script, File.dirname(script), GEMFILE)
    pkg_dir = Dir.glob(File.join(Dir.glob(File.join(Mandy::Packer::TMP_DIR, "*")).last, "*")).collect {|f| File.basename(f)}
  end
  
  after(:each) do
    FileUtils.rm_r(Mandy::Packer::TMP_DIR)
  end
  
  describe "Packing" do
    before(:each) {Dir.stub!(:chdir)} # don't care about the tar'ing
    
    it "bundles script into package directory" do
      package_script(__FILE__).should include("packer_spec.rb")
    end

    it "bundles sub-folders into package directory" do
      sub_dir = FileUtils.mkdir_p(File.join(File.dirname(__FILE__), "sub_folder"))
      
      package_script(__FILE__).should include("sub_folder")
      
      FileUtils.rm_r(sub_dir)
    end
  end
end