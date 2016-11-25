module Browsernizer
  class Config

    def initialize
      @supported = []
      @location = nil
      @exclusions = []
      @handler = lambda { }
    end

    def supported(*args, &block)
      if args.length == 2
        @supported << Browser.new(args[0], args[1])
      elsif block_given?
        @supported << block
      else
        raise ArgumentError, "accepts either (browser, version) or block"
      end
    end

    def unsupported(names)
      if names.is_a? Array
        names.collect {|name| supported(name, false) }
      else
        supported(names, false)
      end
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
