require 'spec_helper'

describe Browsernizer::Router do

  let(:app) { mock() }

  subject do
    Browsernizer::Router.new(app) do |config|
      config.supported "Firefox", "4"
      config.supported "Chrome", "7.1"
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
    it "sets browsernizer env and propagates request" do
      response = default_env.dup
      response['browsernizer'] = {
        'supported' => true,
        'browser' => "Chrome",
        'version' => "7.1.1"
      }
      app.should_receive(:call).with(response)
      subject.call(default_env)
    end
  end

  context "Unsupported Browser" do
    before do
      @env = default_env.merge({
        "HTTP_USER_AGENT" => chrome_agent("7")
      })
    end

    it "updates 'browsernizer' env variable and propagates request" do
      @response = @env.dup
      @response['browsernizer'] = {
        'supported' => false,
        'browser' => "Chrome",
        'version' => "7"
      }
      app.should_receive(:call).with(@response)
      subject.call(@env)
    end

    context "location is set" do
      before do
        subject.config.location "/browser.html"
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

      context "Excluded path" do
        before do
          subject.config.exclude %r{^/assets}
          @env = @env.merge({
            "PATH_INFO" => "/assets/foo.jpg",
          })
        end
        it "propagates request" do
          app.should_receive(:call).with(@env)
          subject.call(@env)
        end
      end
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

      context "exclusions defined" do
        before do
          subject.config.exclude %r{^/assets}
          subject.config.location "/browser.html"
        end
        it "handles the request" do
          app.should_not_receive(:call).with(@env)
          response = subject.call(@env)
          response[0].should == 307
          response[1]["Location"].should == "/browser.html"
        end
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
