module Rediscover
  module Frame
    class CreateKey < Wx::Frame
      include Wx

      def initialize(window, app)
        @app = app
        super(window, -1, 'Create a Key')
        setup_panel
        show
      end

      def setup_panel
        @panel = Panel.new(self)
        @key_label = StaticText.new(@panel, :label => 'Key')
        @key_textbox = TextCtrl.new(@panel)
        @value_label = StaticText.new(@panel, :label => 'Value')
        @value_textbox = TextCtrl.new(@panel)
        @create_button = Button.new(@panel, :label => 'Create')

        evt_button @create_button, :create_evt

        @panel_sizer = BoxSizer.new(VERTICAL)
        @panel.set_sizer(@panel_sizer)
        @panel_sizer.add(@key_label, 0, GROW|ALL, 2)
        @panel_sizer.add(@key_textbox, 0, GROW|ALL, 2)
        @panel_sizer.add(@value_label, 0, GROW|ALL, 2)
        @panel_sizer.add(@value_textbox, 0, GROW|ALL, 2)
        @panel_sizer.add(@create_button, 0, GROW|ALL, 2)
      end

      def on_create(&block)
        @on_create_block = block
      end

      def create_evt
        key = @key_textbox.get_value
        value = @value_textbox.get_value

        begin
          @app.redis[key] = value
        rescue => e
          ExceptionHandler.modal(self, e)
          return
        end

        @on_create_block.call()
        close
      end

    end
  end
end
