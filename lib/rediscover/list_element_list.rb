module Rediscover
  class ListElementList < Wx::ListCtrl
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
    end

    def set_elements(elements)
      delete_all_items
      i = 0
      elements.each { |element| insert_item(i, element); i += 1 }
      @elements = elements
    end

  end
end
