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

    def size
      @keys.size
    end

    def on_get_keys(&block)
      @on_get_keys_block = block
    end

    def update
      @keys = @on_get_keys_block.call()
      size = @keys.size
      @app.logger.debug("KeyListCtrl loaded #{size} keys")
      delete_all_items
      set_item_count(size)
    end

    def on_get_item_text(item, column)
      text = case column
        when COLS.index('Key') then @keys[item]
        when COLS.index('Value') then @app.redis[@keys[item]]
        when COLS.index('Type') then @app.redis.type?(@keys[item])
        when COLS.index('TTL') then @app.redis.ttl(@keys[item]).to_s
      end

      return text || ''
    end

  end
end
