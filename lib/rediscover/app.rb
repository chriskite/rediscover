require 'logger'
require 'rediscover/exception_handler'
require 'rediscover/frame/connect'
require 'rediscover/frame/main'
require 'rediscover/dialog/error'
require 'rediscover/dialog/confirm'

module Rediscover
  class App < Wx::App

    DEFAULTS = {
      :host => 'localhost',
      :port => 6379
    }

    attr_reader :logger, :host, :port, :redis

    def on_init
      @logger = Logger.new(STDOUT)
      ExceptionHandler.set_logger(@logger)
      @host = DEFAULTS[:host]
      @port = DEFAULTS[:port]

      display_connect
    end

    def display_connect
      @connect_frame = Frame::Connect.new
    end

    def display_main
      @main_frame = Frame::Main.new
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
      display_main
    end

  end
end
