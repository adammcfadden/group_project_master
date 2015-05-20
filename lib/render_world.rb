require 'gosu'
require 'sinatra/activerecord'
require './lib/floor'
require './lib/entity'

BOARD_WIDTH = 100
BOARD_HEIGHT = 100
TICKS_PER_STEP = 5

class WorldWindow < Gosu::Window
  def initialize
    super(BOARD_WIDTH*16, BOARD_HEIGHT*16, false) #map size
    self.caption = "Elven Sword!" #window title
    @floor_image = Gosu::Image.new(self, "./media/floor.png", false) # image tile 1
    @wall_image = Gosu::Image.new(self, "./media/wall.gif", false) # image tile 2
    @floor = Floor.new({:width => BOARD_WIDTH, :height => BOARD_HEIGHT}) # call toby's mapmaker
    @floor.generate_map
    @scaler = 16 #scales the size of the image tiles to account for image size
    @countdown = 0 #is used in #update to control player speed
    @player = Entity.create(name: 'Dirge', level: 1, xp: 0, health: 100,  location_x: 1, location_y: 1, pc?: true, image_path: 'media/fox.png', alive?: true, entity_drawn?: false)
    @entity_image = Gosu::Image.new(self, "#{@player.image_path}", false)
  end

  def draw
    #draws map
    @floor.map.each_index do |x|
      @floor.map[x].each_index do |y|
        if(@floor.is_solid?(x, y))
          @wall_image.draw(x*@scaler, y*@scaler, 0)
        else
          @floor_image.draw(x*@scaler, y*@scaler, 0)
        end
      end
    end
    #draws player at random location that is not solid.
    until @player.entity_drawn? do
      unless @floor.is_solid?(@player.location_x, @player.location_y)
        @player.entity_is_drawn
      else
        @player.randomize_coords
      end
    end
    @entity_image.draw(@player.location_x*16, @player.location_y*16, 1)
  end

  def update
    if @countdown > 0 then
      @countdown -= 1
    end
    if button_down? Gosu::KbLeft then
      unless @floor.is_solid?((@player.location_x - 1), @player.location_y)
        if @countdown == 0
          @countdown = TICKS_PER_STEP
          @player.move_west
        end
      end
    end
    if button_down? Gosu::KbRight then
      unless @floor.is_solid?((@player.location_x + 1), @player.location_y)
        if @countdown == 0
          @countdown = TICKS_PER_STEP
          @player.move_east
        end
      end
    end
    if button_down? Gosu::KbUp then
      unless @floor.is_solid?(@player.location_x, @player.location_y - 1)
        if @countdown == 0
          @countdown = TICKS_PER_STEP
          @player.move_north
        end
      end
    end
    if button_down? Gosu::KbDown then
      unless @floor.is_solid?(@player.location_x, @player.location_y + 1)
        if @countdown == 0
          @countdown = TICKS_PER_STEP
          @player.move_south
        end
      end
    end
  end
end
