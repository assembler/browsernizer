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
      handle_request
    end

  private
    def handle_request
      @env["browsernizer"]["supported"] = false if unsupported?

      catch(:response) do
        if !path_excluded?
          if unsupported?
            if !on_redirection_path? && @config.get_location
              throw :response, redirect_to_specified
            end
          elsif on_redirection_path?
            throw :response, redirect_to_root
          end
        end
        propagate_request
      end
    end

    def propagate_request
      @app.call(@env)
    end

    def redirect_to_specified
      [307, {"Content-Type" => "text/plain", "Location" => @config.get_location}, []]
    end

    def redirect_to_root
      [303, {"Content-Type" => "text/plain", "Location" => "/"}, []]
    end

    def path_excluded?
      @config.excluded? @env["PATH_INFO"]
    end

    def on_redirection_path?
      @config.get_location && @config.get_location == @env["PATH_INFO"]
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
