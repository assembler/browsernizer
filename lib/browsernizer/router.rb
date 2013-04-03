module Browsernizer

  class Router
    attr_reader :config

    def initialize(app, &block)
      @app = app
      @config = Config.new
      yield(@config)
    end

    def call(env)
      browser = get_browser(env)
      env["browsernizer"] = {
        "supported" => supported?(env),
        "browser" => browser.name.to_s,
        "version" => browser.version.to_s
      }
      redirect_request(env) || @app.call(@env)
    end

  private

    def redirect_request(env)
      return if path_excluded?(env)
      if !env["browsernizer"]["supported"]
        return redirect_to_specified if @config.get_location && !on_redirection_path?
      elsif on_redirection_path?
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

    def on_redirection_path?
      @config.get_location && @config.get_location == @env["PATH_INFO"]
    end

    def get_raw_browser(env)
      ::Browser.new :ua => env["HTTP_USER_AGENT"]
    end

    def browser(env)
      raw_browser = get_raw_browser(env)
      Browser.new raw_browser.name.to_s, raw_browser.full_version.to_s
    end

    # supported by default
    def supported?(env)
      !@config.get_supported.any? do |requirement|
        supported = if requirement.respond_to?(:call)
          requirement.call(get_raw_browser(env))
        else
          browser.meets?(requirement)
        end
        supported === false
      end
    end
  end

end
