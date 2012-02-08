module Browsernizer

  class Router
    attr_reader :config

    def initialize(app, &block)
      @app = app
      @config = Config.new
      yield(@config)
    end

    def call(env)
      @env = env
      @env["browsernizer"] = {
        "supported" => true,
        "browser" => agent.browser.to_s,
        "version" => agent.version.to_s
      }

      if html_request? && !on_redirection_path? && unsupported?
        handle_unsupported
      elsif html_request? && on_redirection_path? && !unsupported?
        handle_visits_by_accident
      else
        @app.call(env)
      end
    end

  private
    def handle_unsupported
      @env["browsernizer"]["supported"] = false

      if @config.get_location
        [307, {"Content-Type" => "text/plain", "Location" => @config.get_location}, []]
      else
        @app.call(@env)
      end
    end

    def handle_visits_by_accident
      [303, {"Content-Type" => "text/plain", "Location" => "/"}, []]
    end

    def html_request?
      @env["HTTP_ACCEPT"] && @env["HTTP_ACCEPT"].include?("text/html")
    end

    def on_redirection_path?
      @env["PATH_INFO"] && @env["PATH_INFO"] == @config.get_location
    end

    def agent
      ::UserAgent.parse @env["HTTP_USER_AGENT"]
    end

    # supported by default
    def unsupported?
      @config.get_supported.detect do |supported_browser|
        if agent.browser.to_s.downcase == supported_browser.browser.to_s.downcase
          a = BrowserVersion.new agent.version.to_s
          b = BrowserVersion.new supported_browser.version.to_s
          a < b
        end
        # TODO: when useragent is fixed you can use just this line instead the above
        # agent < supported_browser
      end
    end
  end

end
