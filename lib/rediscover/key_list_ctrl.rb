module Rediscover
  class KeyListCtrl < Wx::ListCtrl
    include Wx

    COLS = %w(Key Value Type TTL)

    def initialize(window, app)
      @app = app
      super(window, :style => LC_REPORT|LC_VIRTUAL)
      i = 0
      COLS.each do |name|
        insert_column(i += 1, name)
      end
    end

    def set_keys(keys)
      @keys = keys
      size = keys.size
      @app.logger.debug("KeyListCtrl loaded #{size} keys")
      set_item_count(keys.size)
    end

    def on_get_item_text(item, column)
      case column
        when COLS.index('Key') then @keys[item]
        when COLS.index('Value') then @app.redis[@keys[item]]
        when COLS.index('Type') then @app.redis.type?(@keys[item])
        when COLS.index('TTL') then @app.redis.ttl(@keys[item]).to_s
      end
    end

  end
end
