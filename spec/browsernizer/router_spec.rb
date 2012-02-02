require 'spec_helper'

describe Browsernizer::Router do

  let(:app) { mock() }

  subject do
    Browsernizer::Router.new(app) do |config|
      config.supported "Firefox", "4"
      config.supported "Chrome", "7.1"
      config.location  "/browser.html"
    end
  end

  let(:default_env) do
    {
      "HTTP_USER_AGENT" => chrome_agent("7.1.1"),
      "HTTP_ACCEPT" => "text/html",
      "PATH_INFO" => "/index"
    }
  end

  context "All Good" do
    it "propagates request" do
      app.should_receive(:call).with(default_env)
      subject.call(default_env)
    end
  end

  context "Unsupported Browser" do
    before do
      @env = default_env.merge({
        "HTTP_USER_AGENT" => chrome_agent("7")
      })
    end

    it "prevents propagation" do
      app.should_not_receive(:call)
      subject.call(@env)
    end

    it "redirects to proper location" do
      response = subject.call(@env)
      response[0].should == 307
      response[1]["Location"].should == "/browser.html"
    end

    context "Non-html request" do
      before do
        @env = @env.merge({
          "HTTP_ACCEPT" => "text/css"
        })
      end
      it "propagates request" do
        app.should_receive(:call).with(@env)
        subject.call(@env)
      end
    end

    context "Already on /browser.html page" do
      before do
        @env = @env.merge({
          "PATH_INFO" => "/browser.html"
        })
      end
      it "propagates request" do
        app.should_receive(:call).with(@env)
        subject.call(@env)
      end
    end
  end


  def chrome_agent(version)
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/#{version} Safari/535.7"
  end

end
