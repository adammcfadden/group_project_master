require 'gosu'
require './lib/floor'
require './lib/entity_paint'

class GameWindow < Gosu::Window
  def initialize
    super(1280, 720, false) #map size
    self.caption = "Render Map" #window title
    @floor_image = Gosu::Image.new(self, "./media/floor.png", false) # image tile 1
    @wall_image = Gosu::Image.new(self, "./media/wall.gif", false) # image tile 2
    @floor = Floor.new({:width => 25, :height => 25}) # call toby's mapmaker
    @floor.create_boundaries
    @scaler = 16 #scales the size of the image tiles to account for image size

    @entity_paint = Entity_paint.new(self)
    @entity_paint.warp(13, 13)

  end

  def draw
    @floor.map.each_index do |y|
      @floor.map[y].each_index do |x|
        if(@floor.is_solid?(x, y))
          @wall_image.draw(x*@scaler, y*@scaler, 1)
        else
          @floor_image.draw(x*@scaler, y*@scaler, 1)
        end
      end
    end
    @entity_paint.draw

  end

end

window = GameWindow.new
window.show
