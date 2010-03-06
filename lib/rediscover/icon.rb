module Rediscover
  class Icon < Wx::Icon

    @@icon_dir = File.join( File.dirname(__FILE__), 'icons')

    def initialize(icon_name)
      icon_file = File.join(@@icon_dir, "#{icon_name}.png")
      super(icon_file, Wx::BITMAP_TYPE_PNG)
    end

  end
end
