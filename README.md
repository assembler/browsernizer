# Browsernizer

Want friendly "please upgrade your browser" page? This gem is for you.

You can redirect your visitors to any page you like (static or dynamic).
Just specify `config.location` option in initializer file.


## Installation

Add following line to your `Gemfile`:

    gem 'browsernizer'

Hook it up:

    rails generate browsernizer:install

Configure browser support in `config/initializers/browsernizer.rb` file.


## Configuration

Initializer file is pretty self explanatory. Here is the default one:

    Rails.application.config.middleware.use Browsernizer::Router do |config|
      config.supported "Internet Explorer", "9"
      config.supported "Firefox", "4"
      config.supported "Opera", "11.1"
      config.supported "Chrome", "7"

      config.location  "/browser.html"
      config.exclude   %r{^/assets}
    end

It states that IE9+, FF4+, Opera 11.1+ and Chrome 7+ are supported.
Non listed browsers are considered to be supported regardless of their version.
Unsupported browsers will be redirected to `/browser.html` page.

You can specify which paths you wish to exclude with `exclude` method.
It accepts string or regular expression. You can specify multiple paths by
calling the `config.exclude` multiple times.

If you wish to completely prevent some browsers from accessing website
(regardless of their version), just set browser version to `false`.

    config.supported "Internet Explorer", false

Specifying location is optional. If you prefer handling unsupported browsers on
your own, you can access browsernizer info from `request.env['browsernizer']`
within your controller.

For example, you can set before filter to display flash notice:

    before_filter :check_browser_support

    def check_browser_support
      unless request.env['browsernizer']['supported']
        flash.notice = "Your browser is not supported"
      end
    end

You can also access `browser` and `version` variables from this env hash.


## Browsers

You should specify browser name as a string. Here are the available options:

* Chrome
* Firefox
* Safari
* Opera
* Internet Explorer

And some less popular:

* Android
* webOS
* BlackBerry
* Symbian
* Camino
* Iceweasel
* Seamonkey

Browser detection is done using [useragent gem](https://github.com/josh/useragent).



## Credits and License

Developed by Milovan Zogovic.

This software is released under the Simplified BSD License.

