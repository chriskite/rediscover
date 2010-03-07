require 'rediscover/panel/server'
require 'rediscover/panel/browser'
require 'rediscover/panel/key_list'
require 'rediscover/key_viewer'
require 'rediscover/set_element_list'
require 'rediscover/sorted_set_element_list'
require 'rediscover/list_element_list'
require 'rediscover/panel/string_view'
require 'rediscover/panel/set_view'
require 'rediscover/panel/sorted_set_view'
require 'rediscover/panel/list_view'
require 'rediscover/frame/create_key'

module Rediscover
  module Frame
    class Main < Wx::Frame
      include Wx

      WINDOW_WIDTH = 600
      WINDOW_HEIGHT = 400

      def initialize
        super(nil, -1, 'Rediscover', DEFAULT_POSITION, Size.new(WINDOW_WIDTH, WINDOW_HEIGHT))

        @redis = get_app.redis
        @logger = get_app.logger

        set_icon(Rediscover::Icon.new('application'))

        setup_status_bar
        setup_notebook
        show
      end

      def setup_notebook
        @notebook = Notebook.new(self)

        @server_page = Panel::Server.new(@notebook)
        @browser_page = Panel::Browser.new(@notebook)
        @browser_page.on_status_change { |status| update_status_bar(status) }

        @notebook.add_page(@server_page, 'Server Info', false)
        @notebook.add_page(@browser_page, 'Key Browser', true)
      end

      def setup_status_bar
        @status_bar = create_status_bar(2)
        @status_bar.set_status_widths([-3, -1]) # set fields to variable widths
        update_status_bar
      end

      def update_status_bar(status = nil)
        @status_bar.set_status_text(@redis.to_s, 0) # connection info in left field
        @status_bar.set_status_text(status, 1) if status # key count in right field
      end

    end
  end
end
