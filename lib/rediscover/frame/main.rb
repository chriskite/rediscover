require 'rediscover/panel/browser'
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

        setup_notebook
        setup_tool_bar
        setup_status_bar
        show
      end

      def setup_notebook
        @notebook = Notebook.new(self)
        @browser_page = Panel::Browser.new(@notebook)

        @notebook.add_page(@browser_page, 'Key Browser')
      end

      def setup_tool_bar
        @tool_bar = create_tool_bar
        @filter_textbox = TextCtrl.new(@tool_bar,
                                       :style => TE_PROCESS_ENTER,
                                       :size => Size.new(200, DEFAULT_SIZE.get_height))
        evt_text_enter @filter_textbox, :filter # filter when enter is pressed in the textbox
        @filter_button = Button.new(@tool_bar, :label => 'Filter')
        evt_button @filter_button, :filter # filter when button is pressed
        @tool_bar.add_control(@filter_textbox)
        @tool_bar.add_control(@filter_button)
        @tool_bar.realize
      end

      def setup_status_bar
        @status_bar = create_status_bar(2)
        @status_bar.set_status_widths([-3, -1]) # set fields to variable widths
        update_status_bar
      end

      def update_status_bar
        @status_bar.set_status_text(@redis.to_s, 0) # connection info in left field
        @status_bar.set_status_text(@key_list.size.to_s + ' keys', 1) rescue '' # key count in right field
      end

      def filter
        @logger.debug("Frame::Main#filter not implemented")
      end

    end
  end
end
