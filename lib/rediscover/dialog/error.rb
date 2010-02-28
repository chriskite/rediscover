module Rediscover
  module Dialog
    class Error < Wx::MessageDialog
      include Wx

      def initialize(window, message, caption)
        super(window, message, caption, OK|ICON_ERROR)
      end

    end
  end
end
