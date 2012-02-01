require "browsernizer/version"

module Browsernizer
  # Your code goes here...

  class Router
    def initialize(app)
      @app = app
    end

    def call(env)
      [200, {"Content-Type" => "text/plain"}, ["Success"]]
    end
  end

end
