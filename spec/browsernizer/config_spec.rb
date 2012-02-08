require 'spec_helper'

describe Browsernizer::Config do

  subject { config = Browsernizer::Config.new }

  describe "supported(name, version)" do
    it "defines new supported browser" do
      subject.supported "Chrome", "16.0"
      subject.supported "Firefox", "10.0"
      subject.get_supported.should have(2).items
    end
  end

  describe "location(path)" do
    it "sets the redirection path for unsupported browsers" do
      subject.location "foo.html"
      subject.get_location.should == "foo.html"
    end
  end

end
