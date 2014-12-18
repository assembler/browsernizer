require 'spec_helper'

describe Browsernizer::BrowserVersion do

  describe "Comparable" do

    it "is greater" do
     expect(version("2")).to be > version("1")
     expect(version("1.1")).to be > version("1")
     expect(version("1.1")).to be > version("1.0")
     expect(version("2")).to be > version("1.9")
   end

    it "is equal" do
      expect(version("1")).to eq(version("1"))
      expect(version("1")).to eq(version("1.0"))
      expect(version("1.0")).to eq(version("1"))
    end

    it "handles strings" do
      expect(version("1.0")).to eq(version("1.0.alpha"))
    end

  end


  def version(str)
    Browsernizer::BrowserVersion.new(str)
  end

end
