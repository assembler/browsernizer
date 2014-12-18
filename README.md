# Browsernizer

[![Gem Version](https://badge.fury.io/rb/browsernizer.png)](http://badge.fury.io/rb/browsernizer)

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

There is also an option to provide block for more advanced checking.
[Browser object](https://github.com/fnando/browser/blob/master/lib/browser.rb) will be
passed to it. If you wish to state that *mobile safari* is not supported, you
can declare it like this:

    config.supported do |browser|
      !(browser.name == "Safari" && browser.mobile?)
    end

The block should return false to block the browser, true to allow it, and nil if it
cannot decide. This way you can make any arbitrary User-Agent explicitly allowed,
even if its version would have been blocked otherwise:

    config.supported do |browser|
      true if browser.user_agent.include?('Linux')
    end

Please note, that the order is important, thus the first block or requirement returning
a boolean wins.

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
* BlackBerry
* iPad
* iPhone
* iPod Touch
* PlayStation Portable
* QuickTime
* Apple CoreMedia

Browser detection is done using [browser gem](https://github.com/fnando/browser).



## Credits and License

Developed by Milovan Zogovic.

This software is released under the Simplified BSD License.

