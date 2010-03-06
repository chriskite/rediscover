module Rediscover
  module Panel
    class StringView < Wx::Panel
      include Wx

      attr_accessor :key

      def initialize(parent)
        @parent = parent
        super(@parent, -1)

        @redis = get_app.redis

        setup
      end

      def setup
        @sizer = BoxSizer.new(VERTICAL)
        set_sizer(@sizer)

        @value_textbox = TextCtrl.new(self)

        @save_button = Button.new(self, :label => 'Save')
        evt_button @save_button, :save

        @sizer.add_item(@value_textbox, 0, GROW|ALL, 2)
        @sizer.add_item(@save_button)
      end

      def save
        @redis[@key] = @value_textbox.get_value
      end

    end
  end
end
