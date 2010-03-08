require 'rubygems'
require 'wx'
require 'redis'
require 'rediscover/app'

if not defined?(Ocra)
  Rediscover::App.new.main_loop()
end
