module Rediscover
  class SortedSetElementList < Wx::ListCtrl
    include Wx

    def initialize(parent, key, elements)
      @parent, @key = parent, key
      @redis = get_app.redis
      @logger = get_app.logger

      super(parent, :style => LC_REPORT)

      setup
      set_elements(elements)
    end

    def setup
      insert_column(0, 'Elements')
      set_column_width(LIST_AUTOSIZE, -1)
      evt_list_item_right_click self, :list_item_right_click_evt
    end

    def set_elements(elements)
      delete_all_items
      i = 0
      elements.each { |element| insert_item(i, element); i += 1 }
      @elements = elements
    end

    def delete(selections)
      delete_elements = selections.map { |index| @elements[index] }
      delete_elements.each do |element|
        @elements.delete(element)
        @redis.zrem(@key, element)
        delete_item(find_item(0, element))
      end
      update
      do_on_save
    end

    def list_item_right_click_evt(event)
      menu = get_ctx_menu_for_selections(get_selections)
      popup_menu(menu, event.get_point) if menu
    end

    def get_ctx_menu_for_selections(selections)
      return nil if selections.empty?
      @ctx_menu = Menu.new

      # delete menu item
      @ctx_delete_item = MenuItem.new(@ctx_menu, -1, 'Delete')
      evt_menu(@ctx_delete_item) do
        if ID_YES == Dialog::Confirm.new(self, 'Really delete selected element(s)?', 'Really delete?').show_modal
          delete(selections)
        end
      end

      @ctx_menu.append_item(@ctx_delete_item)
      @ctx_menu
    end

    def on_save(&block)
      @on_save_block = block
    end

    def do_on_save
      @on_save_block.call() if @on_save_block
    end

  end
end
