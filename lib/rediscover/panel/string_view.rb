module Rediscover
  class StringView < Wx::Panel
    include Wx

    def initialize(parent)
      @parent = parent
      super(@parent, -1)

    end

  end
end
