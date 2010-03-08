require 'logger'
require 'forwardable'
require 'rediscover/exception_handler'
require 'rediscover/icon'
require 'rediscover/key_list_ctrl'
require 'rediscover/key_viewer'
require 'rediscover/set_element_list'
require 'rediscover/sorted_set_element_list'
require 'rediscover/list_element_list'
require 'rediscover/frame/connect'
require 'rediscover/frame/main'
require 'rediscover/frame/create_key'
require 'rediscover/dialog/error'
require 'rediscover/dialog/confirm'
require 'rediscover/panel/server'
require 'rediscover/panel/browser'
require 'rediscover/panel/key_list'
require 'rediscover/panel/string_view'
require 'rediscover/panel/set_view'
require 'rediscover/panel/sorted_set_view'
require 'rediscover/panel/list_view'

module Rediscover
  class App < Wx::App

    DEFAULTS = {
      :host => 'localhost',
      :port => 6379
    }

    attr_reader :logger, :host, :port, :redis

    def on_init
      @logger = Logger.new('rediscover.log')
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

      display_main
    end

  end
end
