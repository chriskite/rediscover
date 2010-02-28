module Rediscover
  module Frame
    class Browser < Wx::Frame
      include Wx

      def initialize(app)
        @app = app
        super(nil, -1, 'Rediscover')
        show
      end

    end
  end
end
