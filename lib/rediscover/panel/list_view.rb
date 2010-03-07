module Rediscover
  module Panel
    class ListView < Wx::Panel
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
        members = @redis.lrange(@key, 0, -1)

        @sizer = BoxSizer.new(VERTICAL)
        set_sizer(@sizer)

        @key_label = StaticText.new(self, :label => "Key: #{@key}")

        @element_list = ListElementList.new(self, @key, members)

        @button_sizer = BoxSizer.new(HORIZONTAL)

        @lpush_button = Button.new(self, :label => 'Left Push')
        evt_button(@lpush_button) { push(:lpush) }

        @rpush_button = Button.new(self, :label => 'Right Push')
        evt_button(@rpush_button) { push(:rpush) }

        @lpop_button = Button.new(self, :label => 'Left Pop')
        evt_button(@lpop_button) { pop(:lpop) }

        @rpop_button = Button.new(self, :label => 'Right Pop')
        evt_button(@rpop_button) { pop(:rpop) }

        @close_button = Button.new(self, :label => 'Close')
        evt_button @close_button, :do_on_close

        @sizer.add_item(@key_label, :flag => ALL, :border => 2)
        @sizer.add_item(@element_list, :proportion => 1, :flag => EXPAND|ALL, :border => 2)
        @sizer.add_item(@button_sizer)

        @button_sizer.add_item(@lpush_button, :flag => ALL,  :border => 2)
        @button_sizer.add_item(@rpush_button, :flag => ALL,  :border => 2)
        @button_sizer.add_item(@lpop_button, :flag => ALL,  :border => 2)
        @button_sizer.add_item(@rpop_button, :flag => ALL,  :border => 2)
        @button_sizer.add_item(@close_button, :flag => ALL,  :border => 2)
      end

      def pop(dir = :lpop)
        @redis.send(dir, @key)
        @element_list.set_elements(@redis.lrange(@key, 0, -1))
        do_on_save
      end

      def push(dir = :lpush)
        @add_dlg = TextEntryDialog.new(self, 'Enter a new element:', 'Add Element')
        if @add_dlg.show_modal == ID_OK
          @redis.send(dir, @key, @add_dlg.get_value)
          @element_list.set_elements(@redis.lrange(@key, 0, -1))
          do_on_save
        end
      end

    end
  end
end
