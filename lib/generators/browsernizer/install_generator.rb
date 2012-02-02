module Browsernizer

  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../../templates", __FILE__)

    desc "Copies initializer script"
    def copy_initializer
      copy_file "browsernizer.rb", "config/initializers/browsernizer.rb"
    end
  end

end
