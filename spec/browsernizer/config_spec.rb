require 'spec_helper'

describe Browsernizer::Config do

  subject { config = Browsernizer::Config.new }

  describe "new" do
    it "sets the defaults" do
      subject.get_supported.should == []
      subject.get_location.should == "/unsupported-browser.html"
    end
  end

  describe "supported(name, version)" do
    it "defines new supported browser" do
      subject.supported "Chrome", "16.0"
      subject.supported "Firefox", "10.0"
      subject.get_supported.should have(2).items
    end
  end

  describe "location(path)" do
    it "sets the redirection path for unsupported browsers" do
      subject.location "foo.bar"
      subject.get_location.should == "foo.bar"
    end
  end

end
