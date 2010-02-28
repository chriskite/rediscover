require 'rediscover/frame/connect'
require 'rediscover/frame/browser'

module Rediscover
  class App < Wx::App

    DEFAULTS = {
      :host => 'localhost',
      :port => 6379
    }

    attr_reader :host, :port, :redis

    def on_init
      @host = DEFAULTS[:host]
      @port = DEFAULTS[:port]
      
      display_connect
    end

    def display_connect
      Frame::Connect.new(self)
    end

    def display_browser
      Frame::Browser.new(self)
    end

    def connect(host, port)
      @redis = Redis.new(:host => host, :port => port)
      # connection errors will be rescued by Frame::Connect
      @redis.connect_to_server
      @host = host
      @port = port

      display_browser
    end

  end
end
