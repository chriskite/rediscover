module Rediscover
  module Dialog
    class Confirm < Wx::MessageDialog
      include Wx

      def initialize(window, message, caption)
        super(window, message, caption, YES_NO|ICON_QUESTION)
      end

    end
  end
end
