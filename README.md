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

All browsers that are not listed in initializer file will be considered to be **supported**.


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

I don't believe in licenses and other woody crap.
Do whatever you want with this :)
