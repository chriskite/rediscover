module Rediscover
  module Frame
    class Browser < Wx::Frame
      include Wx

      WINDOW_WIDTH = 600
      WINDOW_HEIGHT = 400

      def initialize(app)
        @app = app
        super(nil, -1, 'Rediscover', DEFAULT_POSITION, Size.new(WINDOW_WIDTH, WINDOW_HEIGHT))
        setup_menu_bar
        setup_status_bar
        setup_key_browser
        show
      end

      def setup_menu_bar
        @menu_bar = MenuBar.new
        set_menu_bar(@menu_bar)

        @keys_menu = create_keys_menu

        @menu_bar.append(@keys_menu, 'Keys')
      end

      def setup_status_bar
        @status_bar = create_status_bar(2)
        @status_bar.set_status_widths([-3, -1]) # set fields to variable widths
        update_status_bar
      end

      def update_status_bar
        @status_bar.set_status_text(@app.redis.to_s, 0) # connection info in left field
        @status_bar.set_status_text(@app.redis.dbsize.to_s + ' keys', 1) # key count in right field
      end

      def setup_key_browser
        @key_list = ListBox.new(self)
        update_key_browser
      end

      def update_key_browser
        labels = @app.redis.keys('*').map { |key| key + ' => ' + @app.redis[key] }
        @key_list.set(labels)
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
        @create_key_frame = Rediscover::Frame::CreateKey.new(self, @app)
        @create_key_frame.on_create { refresh }
      end

      def refresh
        update_key_browser
        update_status_bar
      end

    end
  end
end
