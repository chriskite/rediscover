module Rediscover
  class KeyListCtrl < Wx::ListCtrl
    include Wx

    COLS = %w(Key Value Type TTL)

    def initialize(window)
      @redis = get_app.redis
      @logger = get_app.logger

      super(window, :style => LC_REPORT|LC_VIRTUAL)

      i = 0
      COLS.each do |name|
        insert_column(i += 1, name)
      end

      evt_list_item_right_click self, :list_item_right_click_evt
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
      @logger.debug("KeyListCtrl loaded #{size} keys")
      delete_all_items
      set_item_count(size)
    end

    def delete(selections)
      selections.each do |index|
        key = @keys[index]
        @redis.delete(key)
      end
      update
    end

    def on_get_item_text(item, column)
      text = case column
        when COLS.index('Key') then @keys[item]
        when COLS.index('Value') then get_item_value(item)
        when COLS.index('Type') then get_item_type(item)
        when COLS.index('TTL') then @redis.ttl(@keys[item]).to_s
      end

      return text || ''
    end

    def get_item_type(item)
      @redis.type?(@keys[item])
    end

    def get_item_value(item)
      case get_item_type(item)
        when 'string' then return @redis[@keys[item]]
        when 'list' then return "#{@redis.list_length(@keys[item])} element(s)" 
        when 'set' then return "#{@redis.set_count(@keys[item])} element(s)"
        when 'zset' then return "#{@redis.zset_count(@keys[item])} element(s)"
      end
    end

    def list_item_right_click_evt(event)
      menu = get_ctx_menu_for_selections(get_selections)
      popup_menu(menu, event.get_point) if menu
    end

    def get_ctx_menu_for_selections(selections)
      return nil if selections.empty?
      @ctx_menu = Menu.new
      @ctx_delete_item = MenuItem.new(@ctx_menu, -1, 'Delete')
      evt_menu(@ctx_delete_item) do
        if ID_YES == Dialog::Confirm.new(self, 'Really delete selected key(s)?', 'Really delete?').show_modal
          delete(selections)
        end
      end
      @ctx_menu.append_item(@ctx_delete_item)
      @ctx_menu
    end

  end
end
