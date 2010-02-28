module Rediscover
  module Frame
    include Wx

    class Connect < Wx::Frame

      def initialize(ctx)
        @ctx = ctx
        super(nil, -1, 'Connect to Redis')
        show
      end

    end

  end
end
