module Rediscover
  module Panel
    class StringView < Wx::Panel
      include Wx

      def initialize(parent, key)
        @parent = parent
        super(@parent, -1, :style => SUNKEN_BORDER)

        @key = key
        @redis = get_app.redis

        setup
      end

      def setup
        value = @redis[@key]

        @sizer = BoxSizer.new(VERTICAL)
        set_sizer(@sizer)

        @key_label = StaticText.new(self, :label => "Key: #{@key}")

        @value_textbox = TextCtrl.new(self, :value => value, :style => TE_MULTILINE|TE_DONTWRAP)

        @button_sizer = BoxSizer.new(HORIZONTAL)

        @save_button = Button.new(self, :label => 'Save')
        evt_button @save_button, :save

        @close_button = Button.new(self, :label => 'Close')
        evt_button @close_button, :do_on_close

        @sizer.add_item(@key_label, :flag => ALL, :border => 2)
        @sizer.add_item(@value_textbox, :proportion => 1, :flag => EXPAND|ALL, :border => 2)
        @sizer.add_item(@button_sizer)

        @button_sizer.add_item(@save_button, :flag => ALL,  :border => 2)
        @button_sizer.add_item(@close_button, :flag => ALL,  :border => 2)
      end

      def save
        @redis[@key] = @value_textbox.get_value
        do_on_save
      end

      def on_save(&block)
        @on_save_block = block
      end

      def do_on_save
        @on_save_block.call() if @on_save_block
      end

      def on_close(&block)
        @on_close_block = block
      end

      def do_on_close
        @on_close_block.call() if @on_close_block
      end

    end
  end
end
