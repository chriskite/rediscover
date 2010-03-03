require 'rediscover/key_list_ctrl'

module Rediscover
  module Frame
    class Browser < Wx::Frame
      include Wx

      WINDOW_WIDTH = 600
      WINDOW_HEIGHT = 400

      def initialize
        @redis = get_app.redis
        @key_pattern = '*'
        super(nil, -1, 'Rediscover', DEFAULT_POSITION, Size.new(WINDOW_WIDTH, WINDOW_HEIGHT))
        setup_menu_bar
        setup_tool_bar
        setup_key_browser
        setup_status_bar
        setup_key_shortcuts
        show
      end

      def setup_key_shortcuts
        evt_key_up { |event| refresh if event.get_key_code == K_F5 }
      end

      def setup_menu_bar
        @menu_bar = MenuBar.new
        set_menu_bar(@menu_bar)

        @keys_menu = create_keys_menu

        @menu_bar.append(@keys_menu, 'Keys')
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

      def setup_key_browser
        @key_list = KeyListCtrl.new(self)
        @key_list.on_get_keys { @redis.keys(@key_pattern).sort }
        @key_list.update
      end

      def create_keys_menu
        menu = Menu.new

        create_key_item = menu.append('Create a Key', 'Create a new key/value pair')
        evt_menu create_key_item, :create_key_evt

        refresh_item = menu.append('Refresh', 'Refresh the key browser')
        evt_menu refresh_item, :refresh

        menu
      end

      def create_key_evt
        @create_key_frame = Rediscover::Frame::CreateKey.new(self)
        @create_key_frame.on_create { refresh }
      end

      def refresh
        @key_list.update
        update_status_bar
      end

      def filter
        @key_pattern = @filter_textbox.get_value.strip
        @key_pattern = '*' if @key_pattern.nil? or @key_pattern == ''
        refresh
      end

    end
  end
end
