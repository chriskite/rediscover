module Rediscover
  module Frame
    class Browser < Wx::Frame
      include Wx

      WINDOW_WIDTH = 600
      WINDOW_HEIGHT = 400

      def initialize(app)
        @app = app
        super(nil, -1, 'Rediscover', DEFAULT_POSITION, Size.new(WINDOW_WIDTH, WINDOW_HEIGHT))
        setup_status_bar
        show
      end

      def setup_status_bar
        @status_bar = create_status_bar(2)
        @status_bar.set_status_text(@app.redis.to_s, 0) # connection info in left field
        @status_bar.set_status_text(@app.redis.dbsize.to_s + ' keys', 1) # key count in right field
        # set fields to variable widths
        @status_bar.set_status_widths([-3, -1])
      end

    end
  end
end
