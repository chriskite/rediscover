require 'rediscover/key_list_ctrl'

module Rediscover
  module Panel
    class KeyList < Wx::Panel
      include Wx
      extend Forwardable

      def_delegators :@key_list, :on_edit

      def initialize(parent)
        @parent = parent
        super(@parent, -1, :style => SUNKEN_BORDER)

        @redis = get_app.redis
        @logger = get_app.logger
        @key_pattern = '*'

        setup_sizer
        setup_tool_bar
        setup_key_browser
        setup_key_shortcuts
      end

      def setup_sizer
        @sizer = BoxSizer.new(VERTICAL)
        set_sizer(@sizer)
      end

      def setup_tool_bar
        @tool_bar_sizer = BoxSizer.new(HORIZONTAL)
        @sizer.add_item(@tool_bar_sizer)

        @add_button = Button.new(self, ID_ADD)
        evt_button(@add_button) do
          create_key_frame = Rediscover::Frame::CreateKey.new(self)
          create_key_frame.on_create { refresh }
        end

        @refresh_button = Button.new(self, ID_REFRESH)
        evt_button @refresh_button, :refresh

        # filter input and button
        @filter_textbox = TextCtrl.new(self,
                                       :style => TE_PROCESS_ENTER,
                                       :size => Size.new(200, -1))
        evt_text_enter @filter_textbox, :filter # filter when enter is pressed in the textbox
        @filter_button = Button.new(self, :label => 'Filter')
        evt_button @filter_button, :filter # filter when button is pressed

        # add elements to tool bar
        @tool_bar_sizer.add_item(@add_button, :flag => ALL, :border => 1)
        @tool_bar_sizer.add_item(@refresh_button, :flag => ALL, :border => 1)
        @tool_bar_sizer.add_item(@filter_textbox, :flag => ALL, :border => 1)
        @tool_bar_sizer.add_item(@filter_button, :flag => ALL, :border => 1)
      end

      def setup_key_shortcuts
        evt_key_up { |event| refresh if event.get_key_code == K_F5 }
      end

      def setup_key_browser
        @key_list = KeyListCtrl.new(self)
        @sizer.add(@key_list, 1, EXPAND)
        @key_list.on_get_keys { @redis.keys(@key_pattern).sort }
        @key_list.update
      end

      def refresh(item = nil)
        if(item)
          @key_list.refresh_item(item)
        else
          @key_list.update
        end
      end

      def filter
        @key_pattern = @filter_textbox.get_value.strip
        @key_pattern = '*' if @key_pattern.nil? or @key_pattern == ''
        refresh
      end

    end
  end
end
