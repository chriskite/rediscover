module Rediscover
  module Panel
    class Browser < Wx::SplitterWindow
      include Wx

      def initialize(parent)
        @parent = parent
        super(@parent, -1)

        @redis = get_app.redis
        @logger = get_app.logger

        @key_list_panel = Panel::KeyList.new(self)
        @key_list_panel.on_edit { |key, type, item| edit(key, type, item)}

        init(@key_list_panel) # just show the key list initially
      end

      def edit(key, type, item)
        unsplit(@view_panel) if @view_panel

        @view_panel = get_view_panel(key, type)
        @view_panel.on_save { @key_list_panel.refresh(item) }
        @view_panel.on_close { unsplit(@view_panel) }

        split_horizontally(@key_list_panel, @view_panel)
      end

      def get_view_panel(key, type)
        Panel::StringView.new(self, key)
      end

    end
  end
end
