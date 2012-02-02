module Browsernizer
  class Config

    def initialize
      @supported = []
      @location = "/unsupported-browser.html"
    end

    def supported(browser, version)
      @supported << Browser.new(browser.to_s, version.to_s)
    end

    def location(path)
      @location = path
    end

    def get_supported
      @supported
    end

    def get_location
      @location
    end

  end
end
