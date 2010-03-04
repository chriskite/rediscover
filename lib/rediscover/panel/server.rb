module Rediscover
  module Panel
    class Server < Wx::Panel
      include Wx

      REFRESH_INTERVAL = 5000
      
      def initialize(parent)
        @parent = parent
        super(@parent, -1)

        @redis = get_app.redis
        @logger = get_app.logger

        setup_sizer
        setup_server_info
      end
      
      def setup_sizer
        @sizer = BoxSizer.new(VERTICAL)
        set_sizer(@sizer)
      end

      def setup_server_info
        @server_info_text = StaticText.new(self, :label => get_info)
        @sizer.add_item(@server_info_text)
        timer = Timer.new(self)
        evt_timer(timer.id) { refresh }
        timer.start(REFRESH_INTERVAL)
      end
      
      def get_info
        @redis.info.map { |key, value| "#{key}: #{value}" }.sort.join("\n")
      end
      
      def refresh
        @server_info_text.set_label(get_info)
      end
      
    end
  end
end