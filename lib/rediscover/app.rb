require 'logger'
require 'rediscover/frame/connect'
require 'rediscover/frame/browser'
require 'rediscover/dialog/warn'

module Rediscover
  class App < Wx::App

    DEFAULTS = {
      :host => 'localhost',
      :port => 6379
    }

    attr_reader :logger, :host, :port, :redis

    def on_init
      @logger = Logger.new(STDOUT)
      @host = DEFAULTS[:host]
      @port = DEFAULTS[:port]

      display_connect
    end

    def display_connect
      @connect_frame = Frame::Connect.new(self)
    end

    def display_browser
      @browser_frame = Frame::Browser.new(self)
    end

    def connect(host, port)
      @redis = Redis.new(:host => host, :port => port)
      @redis.connect_to_server # connection errors will be rescued by Frame::Connect
      @host, @port = host, port

      @logger.info(@redis.to_s)

      display_browser
    end

  end
end
