require 'spec_helper'

describe Browsernizer::Config do

  subject { config = Browsernizer::Config.new }

  describe "supported(name, version)" do
    it "defines new supported browser" do
      subject.supported "Chrome", "16.0"
      subject.supported "Firefox", "10.0"
      expect(subject.get_supported.size).to eq(2)
    end

    it "allows to unsupport browser by using false as version number" do
      subject.supported "Chrome", false
      expect(subject.get_supported[0].version).to be false
    end
  end

  describe "location(path)" do
    it "sets the redirection path for unsupported browsers" do
      subject.location "foo.html"
      expect(subject.get_location).to eq("foo.html")
    end
  end

  describe "exclude(path)" do
    it "defines new excluded path" do
      subject.exclude %r{^/assets}
      subject.exclude "/foo/bar.html"

      expect(subject.excluded?("/assets/foo.jpg")).to be true
      expect(subject.excluded?("/Assets/foo.jpg")).to be false
      expect(subject.excluded?("/prefix/assets/foo.jpg")).to be false
      expect(subject.excluded?("/foo/bar.html")).to be true
      expect(subject.excluded?("/foo/bar2.html")).to be false
    end
  end

end
