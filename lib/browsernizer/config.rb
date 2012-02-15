module Browsernizer
  class Config

    def initialize
      @supported = []
      @location = nil
      @exclusions = []
      @handler = lambda { }
    end

    def supported(browser, version)
      @supported << Browser.new(browser, version)
    end

    def location(path)
      @location = path
    end

    def exclude(path)
      @exclusions << path
    end

    def get_supported
      @supported
    end

    def get_location
      @location
    end

    def excluded?(path)
      @exclusions.any? do |exclusion|
        case exclusion
        when String
          exclusion == path
        when Regexp
          exclusion =~ path
        end
      end
    end

  end
end
