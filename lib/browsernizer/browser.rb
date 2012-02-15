module Browsernizer

  class Browser

    attr_reader :name, :version

    def initialize(name, version)
      @name = name.to_s
      if version === false
        @version = false
      else
        @version = BrowserVersion.new version.to_s
      end
    end

    def meets?(requirement)
      if name.downcase == requirement.name.downcase
        if requirement.version === false
          false
        else
          version >= requirement.version
        end
      else
        nil
      end
    end

  end

end
