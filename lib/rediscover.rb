$:.unshift File.dirname(__FILE__)
require 'rubygems'
require 'wx'
require 'redis'
require 'logger'
require 'forwardable'
require 'rediscover/app'

if not defined?(Ocra)
    Rediscover::App.new.main_loop()
end
