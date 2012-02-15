require 'spec_helper'

describe Browsernizer::Browser do

  describe "#meets?(requirement)" do
    context "same vendor" do
      it "returns true if version is >= to requirement" do
        browser("Chrome", "10.0").meets?(browser("Chrome", "10"  )).should be_true
        browser("Chrome", "10.0").meets?(browser("Chrome", "10.1")).should be_false
        browser("Chrome", "10"  ).meets?(browser("Chrome", " 9.1")).should be_true
      end
      it "returns false if requirement version is set to false" do
        browser("Chrome", "10"  ).meets?(browser("Chrome", false )).should be_false
      end
    end

    context "different vendors" do
      it "returns nil" do
        browser("Chrome", "10").meets?(browser("Firefox", "10")).should be_nil
      end
    end
  end

  def browser(name, version)
    Browsernizer::Browser.new(name, version)
  end

end
