#TODO: remove when useragent gem is fixed
require 'rubygems'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])


require "browsernizer/browser"
require "browsernizer/config"
require "browsernizer/router"
require "browsernizer/version"
require 'useragent'
