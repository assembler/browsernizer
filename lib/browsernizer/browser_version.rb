module Browsernizer
  class BrowserVersion
    include ::Comparable

    attr_accessor :to_a

    def initialize(version)
      @version = version
    end

    def to_a
      @version.split(".").map{ |s| s.to_i }
    end

    def <=>(other)
      ([0]*6).zip(to_a, other.to_a).each do |dump, a, b|
        r = (a||0) <=> (b||0)
        return r unless r.zero?
      end
      0
    end

  end
end
