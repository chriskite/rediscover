module Rediscover
  module Panel
    class SetView < Wx::Panel
      include Wx

      def initialize(parent, key)
        @parent = parent
        super(@parent, -1, :style => SUNKEN_BORDER)

        @key = key
        @redis = get_app.redis
        @logger = get_app.logger

        setup
      end

      def setup
        @logger.debug("SetView#setup not implemented")        
      end

      def on_close(&block)
        @on_close_block = block
      end

      def do_on_close
        @on_close_block.call() if @on_close_block
      end

    end
  end
end
