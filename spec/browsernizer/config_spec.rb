require 'spec_helper'

describe Browsernizer::Config do

  subject { config = Browsernizer::Config.new }

  describe "supported(name, version)" do
    it "defines new supported browser" do
      subject.supported "Chrome", "16.0"
      subject.supported "Firefox", "10.0"
      subject.get_supported.should have(2).items
    end

    it "allows to unsupport browser by using false as version number" do
      subject.supported "Chrome", false
      subject.get_supported[0].version.should be_false
    end
  end

  describe "unsupported(name)" do
    it "defines a new support entry for a browser" do
      subject.unsupported "Firefox"
      subject.get_supported.should have(1).item
    end

    it "defines an unsupported browser" do
      subject.unsupported "Chrome"
      subject.get_supported[0].version.should be_false
    end

    it "allows to 'unsupport' multiple browsers at once" do
      subject.unsupported %w(Firefox Chrome)
      subject.get_supported.should have(2).items
    end
  end

  describe "location(path)" do
    it "sets the redirection path for unsupported browsers" do
      subject.location "foo.html"
      subject.get_location.should == "foo.html"
    end
  end

  describe "exclude(path)" do
    it "defines new excluded path" do
      subject.exclude %r{^/assets}
      subject.exclude "/foo/bar.html"

      subject.excluded?("/assets/foo.jpg").should be_true
      subject.excluded?("/Assets/foo.jpg").should be_false
      subject.excluded?("/prefix/assets/foo.jpg").should be_false
      subject.excluded?("/foo/bar.html").should be_true
      subject.excluded?("/foo/bar2.html").should be_false
    end
  end

end
