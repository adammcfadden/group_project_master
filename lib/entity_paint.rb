class Entity_paint
  def initialize(window)
    @image = Gosu::Image.new(window, "media/one.png", false)
  end

  def warp(x, y)
    @x, @y = x*16, y*16
  end

  def draw
    @image.draw(@x, @y, 2)
  end

end
