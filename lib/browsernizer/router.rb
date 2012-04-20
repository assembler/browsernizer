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
        "browser" => agent.name.to_s,
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

    def raw_agent
      ::UserAgent.parse @env["HTTP_USER_AGENT"]
    end

    def agent
      Browser.new raw_agent.browser.to_s, raw_agent.version.to_s
    end

    # supported by default
    def unsupported?
      @config.get_supported.any? do |requirement|
        supported = if requirement.respond_to?(:call)
          requirement.call(raw_agent)
        else
          agent.meets?(requirement)
        end
        supported === false
      end
    end
  end

end
