class Floor

  attr_reader(:width, :height, :map)

  def initialize (attributes)
    @width = attributes[:width]
    @height = attributes[:height]
    @map = Array.new(@width)
    @map.each_index() do |index|
      @map[index] = Array.new(@height, false)
    end
  end

  def fill_map (with_solid)
    @map.each_index() do |x|
      @map[x].each_index() do |y|
        set_is_solid(x, y, with_solid)
      end
    end
  end

  def create_boundaries
    @map.each_index() do |x|
      @map[x].each_index() do |y|
        if(x == 0 || y == 0 || x == @width-1 || y == @height-1)
          set_is_solid(x, y, true)
        end
      end
    end
  end

  # The "drunkard's walk" algorithim: http://www.roguebasin.com/index.php?title=Random_Walk_Cave_Generation
  def drunk_walk (steps, is_filling)
    x = (@width/2).floor()
    y = (@height/2).floor()
    set_is_solid(x, y, is_filling)
    (steps-1).times() do
      new_coordinates = random_step(x, y)
      while(!is_within_map?(new_coordinates[:x], new_coordinates[:y])) do
        new_coordinates = random_step(x, y)
      end
      x = new_coordinates[:x]
      y = new_coordinates[:y]
      set_is_solid(x, y, is_filling)
    end
  end

  # The cellular automata algorithim: http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels

  def create_caverns
    randomize_map()
    iterate_automata()
    iterate_automata()
    drunk_walk(500, false)
    iterate_automata()
    create_boundaries()
  end

  def randomize_map
    @map.each_index() do |x|
      @map[x].each_index() do |y|
        set_is_solid(x, y, rand(2) == 0)
      end
    end
  end

  def iterate_automata
    temp_floor = self
    (@height).times do |y|
      (@width).times do |x|
        if(empty_neighbors(x, y, 1) >= 5)
          temp_floor.set_is_solid(x, y, true)
        elsif(empty_neighbors(x, y, 2) <= 6)
          temp_floor.set_is_solid(x, y, true)
        else
          temp_floor.set_is_solid(x, y, false)
        end
      end
    end
    @map = temp_floor.map
  end

  def empty_neighbors (cell_x, cell_y, radius)
    empty_neighbors = 0
    x = cell_x - radius
    while(x <= cell_x + radius)
      y = cell_y - radius
      while(y <= cell_y + radius)
        if(is_within_map?(x, y) && !is_solid?(x, y))
          empty_neighbors += 1
        end
        y += 1
      end
      x += 1
    end
    return empty_neighbors
  end

  def random_step (x, y)
    direction = rand(4)
    if(direction == 0)      # step up
      y -= 1
    elsif(direction == 2)   # step down
      y += 1
    elsif(direction == 3)   # step left
      x -= 1
    else                    # step right
      x += 1
    end
    return {:x => x, :y => y}
  end

  def is_within_map? (x, y)
    return x >= 0 && y >= 0 && x < @width && y < @height
  end

  def is_solid? (x, y)
    return @map[x][y]
  end

  def set_is_solid (x, y, is_solid)
    @map[x][y] = is_solid
  end

  # BELOW FUNCTIONS FOR TESTING ONLY

  def self.make_test_floor
    return Floor.new({:width => 25, :height => 25})
  end

  def print_map
    (@height).times do |y|
      (@width).times do |x|
        if(is_solid?(x, y))
          print("#")
        else
          print(".")
        end
      end
      print("\n")
    end
  end

end
