module Rediscover
  class KeyListCtrl < Wx::ListCtrl
    include Wx

    COLS = %w(Key Value Type)

    def initialize(window)
      @redis = get_app.redis
      @logger = get_app.logger

      super(window, :style => LC_REPORT|LC_VIRTUAL)

      i = 0
      COLS.each do |name|
        insert_column(i += 1, name)
      end
      set_column_width(0, 200)
      set_column_width(1, 300)

      evt_list_item_right_click self, :list_item_right_click_evt
      evt_list_item_activated self, :list_item_activated_evt
    end

    def size
      @keys.size
    end

    def on_get_keys(&block)
      @on_get_keys_block = block
    end

    def update
      @keys = @on_get_keys_block.call()
      delete_all_items
      set_item_count(size)
      do_on_status_change
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
      end

      return text || ''
    end

    def get_item_type(item)
      if @cached_item.nil? || @cached_item[:index] != item
        @cached_item = {}
        @cached_item[:index] = item
        @cached_item[:type] = @redis.type?(@keys[item])
      end
      @cached_item[:type]
    end

    def get_item_value(item)
      case get_item_type(item)
        when 'string' then return @redis[@keys[item]]
        when 'list' then return "#{@redis.list_length(@keys[item])} element(s)"
        when 'set' then return "#{@redis.set_count(@keys[item])} element(s)"
        when 'zset' then return "#{@redis.zset_count(@keys[item])} element(s)"
      end
    end

    def list_item_activated_evt
      do_on_edit(*get_selections)
    end

    def list_item_right_click_evt(event)
      menu = get_ctx_menu_for_selections(get_selections)
      popup_menu(menu, event.get_point) if menu
    end

    def get_ctx_menu_for_selections(selections)
      return nil if selections.empty?
      @ctx_menu = Menu.new

      if selections.size == 1 && @redis.type?(@keys[*selections]) != 'none'
        @ctx_edit_item = MenuItem.new(@ctx_menu, -1, 'Edit')
        evt_menu(@ctx_edit_item) { do_on_edit(*selections) }
      end

      # delete menu item
      @ctx_delete_item = MenuItem.new(@ctx_menu, -1, 'Delete')
      evt_menu(@ctx_delete_item) do
        if ID_YES == Dialog::Confirm.new(self, 'Really delete selected key(s)?', 'Really delete?').show_modal
          delete(selections)
        end
      end

      @ctx_menu.append_item(@ctx_edit_item) if @ctx_edit_item
      @ctx_menu.append_item(@ctx_delete_item)
      @ctx_menu
    end

    def on_edit(&block)
      @on_edit_block = block
    end

    def do_on_edit(selection)
      key = @keys[selection]
      @on_edit_block.call(key, @redis.type?(key), selection)
    end

    def on_status_change(&block)
      @on_status_change_block = block
      do_on_status_change
    end

    def do_on_status_change
      @on_status_change_block.call("#{size} keys") if @on_status_change_block
    end

  end
end
