require 'logger'
require 'rediscover/frame/connect'
require 'rediscover/frame/browser'
require 'rediscover/dialog/error'

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
      begin
        @redis = Redis.new(:host => host, :port => port)
        @redis.connect_to_server # connection errors will be rescued by Frame::Connect
        @host, @port = host, port
        @connect_frame.close
      rescue => e
        logger.error(e)
        @conn_refused_dlg = Dialog::Error.new(@connect_frame,
                                                "Can't connect to server.",
                                                'Unable to Connect')
        @conn_refused_dlg.show_modal
        return
      end

      @logger.info(@redis.to_s)
      display_browser
    end

  end
end
