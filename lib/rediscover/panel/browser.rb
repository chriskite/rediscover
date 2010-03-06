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
        @key_list_panel.on_edit { |key| edit(key)}

        init(@key_list_panel) # just show the key list initially
      end

      def edit(key)
        @logger.debug("Editing #{key}")
        @view_panel = Panel::StringView.new(self, key)
        split_horizontally(@key_list_panel, @view_panel)
      end

    end
  end
end
