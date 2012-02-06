require 'spec_helper'

describe Browsernizer::BrowserVersion do

  describe "Comparable" do

    it "is greater" do
     version("2").should > version("1")
     version("1.1").should > version("1")
     version("1.1").should > version("1.0")
     version("2").should > version("1.9")
   end

    it "is equal" do
      version("1").should == version("1")
      version("1").should == version("1.0")
      version("1.0").should == version("1")
    end

    it "handles strings" do
      version("1.0").should == version("1.0.alpha")
    end

  end


  def version(str)
    Browsernizer::BrowserVersion.new(str)
  end

end
