require 'spec_helper'

describe Browsernizer::Browser do

  describe "#meets?(requirement)" do
    context "same vendor" do
      it "returns true if version is >= to requirement" do
        expect(browser("Chrome", "10.0").meets?(browser("Chrome", "10"  ))).to be_truthy
        expect(browser("Chrome", "10.0").meets?(browser("Chrome", "10.1"))).to be_falsey
        expect(browser("Chrome", "10"  ).meets?(browser("Chrome", " 9.1"))).to be_truthy
      end
      it "returns false if requirement version is set to false" do
        expect(browser("Chrome", "10"  ).meets?(browser("Chrome", false ))).to be_falsey
      end
    end

    context "different vendors" do
      it "returns nil" do
        expect(browser("Chrome", "10").meets?(browser("Firefox", "10"))).to be_nil
      end
    end
  end

  def browser(name, version)
    Browsernizer::Browser.new(name, version)
  end

end
