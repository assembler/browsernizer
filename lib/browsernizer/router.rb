module Browsernizer

  class Router
    attr_reader :config

    def initialize(app, &block)
      @app = app
      @config = Config.new
      yield(@config)
    end

    def call(env)
      raw_browser, browser = get_browsers(env)
      env["browsernizer"] = {
        "supported" => supported?(raw_browser, browser),
        "browser" => browser.name.to_s,
        "version" => browser.version.to_s
      }
      redirect_request(env) || @app.call(env)
    end

  private

    def redirect_request(env)
      return if path_excluded?(env)
      if !env["browsernizer"]["supported"]
        return redirect_to_specified if @config.get_location && !on_redirection_path?(env)
      elsif on_redirection_path?(env)
        return redirect_to_root
      end
    end

    def redirect_to_specified
      [307, {"Content-Type" => "text/plain", "Location" => @config.get_location}, []]
    end

    def redirect_to_root
      [303, {"Content-Type" => "text/plain", "Location" => "/"}, []]
    end

    def path_excluded?(env)
      @config.excluded? env["PATH_INFO"]
    end

    def on_redirection_path?(env)
      @config.get_location && @config.get_location == env["PATH_INFO"]
    end

    def get_browsers(env)
      raw_browser = Clients::Info.new :user_agent => env["HTTP_USER_AGENT"]
      browser = Browsernizer::Browser.new raw_browser.browser_name, raw_browser.browser_version
      [raw_browser, browser]
    end

    # supported by default
    def supported?(raw_browser, browser)
      @config.get_supported.inject(true) do |default, requirement|
        supported = if requirement.respond_to?(:call)
          requirement.call(raw_browser)
        else
          browser.meets?(requirement)
        end
        break supported unless supported.nil?
        default
      end
    end
  end

end
