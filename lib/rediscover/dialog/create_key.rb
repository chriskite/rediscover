module Rediscover
  module Dialog
    class CreateKey < Wx::Dialog
      include Wx

      def initialize(window)
        super(window, -1, 'Create a Key')
      end

    end
  end
end
