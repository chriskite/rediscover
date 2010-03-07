module Rediscover
  module Panel
    class SetView < Wx::Panel
      include Wx
      include KeyViewer

      def initialize(parent, key)
        @parent, @key = parent, key
        @redis = get_app.redis
        @logger = get_app.logger

        super(@parent, -1, :style => SUNKEN_BORDER)

        setup
      end

      def setup
        members = @redis.smembers(@key)

        @sizer = BoxSizer.new(VERTICAL)
        set_sizer(@sizer)

        @key_label = StaticText.new(self, :label => "Key: #{@key}")

        @element_list = ElementListCtrl.new(self, @key, members)
        @element_list.on_save { do_on_save }

        @button_sizer = BoxSizer.new(HORIZONTAL)

        @add_button = Button.new(self, :label => 'Add Element')
        evt_button @add_button, :add

        @close_button = Button.new(self, :label => 'Close')
        evt_button @close_button, :do_on_close

        @sizer.add_item(@key_label, :flag => ALL, :border => 2)
        @sizer.add_item(@element_list, :proportion => 1, :flag => EXPAND|ALL, :border => 2)
        @sizer.add_item(@button_sizer)

        @button_sizer.add_item(@add_button, :flag => ALL,  :border => 2)
        @button_sizer.add_item(@close_button, :flag => ALL,  :border => 2)
      end

      def add
        @add_dlg = TextEntryDialog.new(self, 'Enter a new element:', 'Add Element')
        if @add_dlg.show_modal == ID_OK
          @redis.sadd(@key, @add_dlg.get_value)
          @element_list.set_elements(@redis.smembers(@key))
          do_on_save
        end
      end

    end
  end
end
