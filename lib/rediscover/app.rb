require 'rediscover/context'
require 'rediscover/frame/connect'

module Rediscover
  class App < Wx::App

    def on_init
      ctx = Context.new
      Frame::Connect.new(ctx)
    end

  end
end
