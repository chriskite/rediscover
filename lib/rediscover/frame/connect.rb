module Rediscover
  module Frame

    class Connect < Wx::Frame
      include Wx

      def initialize(app)
        @app = app
        super(nil, -1, 'Connect to Redis')
        setup_panel
        show
      end

      def setup_panel
        @panel = Panel.new(self)
        @host_label = StaticText.new(@panel, :label => 'Host')
        @host_textbox = TextCtrl.new(@panel, :value => @app.host)
        @port_label = StaticText.new(@panel, :label => 'Port')
        @port_textbox = TextCtrl.new(@panel, :value => @app.port.to_s)
        @connect_button = Button.new(@panel, :label => 'Connect')

        evt_button @connect_button, :connect_button_evt

        @panel_sizer = BoxSizer.new(VERTICAL)
        @panel.set_sizer(@panel_sizer)
        @panel_sizer.add(@host_label, 0, GROW|ALL, 2)
        @panel_sizer.add(@host_textbox, 0, GROW|ALL, 2)
        @panel_sizer.add(@port_label, 0, GROW|ALL, 2)
        @panel_sizer.add(@port_textbox, 0, GROW|ALL, 2)
        @panel_sizer.add(@connect_button, 0, GROW|ALL, 2)
      end

      def connect_button_evt
        host = @host_textbox.get_value
        port = @port_textbox.get_value.to_i
        @app.connect(host, port)
      end

    end
  end
end
