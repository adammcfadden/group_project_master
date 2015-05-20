require 'gosu'

require 'sinatra/activerecord'
require 'pg'

require('./lib/battle')
require('./lib/entity')

WIDTH = 1600
HEIGHT = 1280

class BattleWindow < Gosu::Window
  def initialize
#   super(screen_width, screen_height, false)
    super(WIDTH, HEIGHT, false) #map size
    self.caption = "Fight!" #window title
    @player_image = Gosu::Image.new(self, "./media/baby_fox_mccloud.jpg", false) # image tile 1
    @vs_image = Gosu::Image.new(self, "./media/vs.png", false)
    # @flee_image = Gosu::Image.new(self, "./media/fox_runs.gif", false)
    # @attack_image = Gosu::Image.new(self, "./media/sword.png", false)
    @monster_image = Gosu::Image.new(self, "./media/baby_gojira.png", false) # image tile 2
    @player_attack_sound = Gosu::Sample.new(self, "media/fox_taunt.wav")
    @monster_attack_sound = Gosu::Sample.new(self, "media/godzilla_roars.wav")
    @player_flee_sound = Gosu::Sample.new(self, "media/fox_flee.wav")
    @font = Gosu::Font.new(self, "Arial", 18)

    @monster = Entity.create(name: 'Gojira', level: 1, xp: 0, health: 100,  location_x: 1, location_y: 1, pc?: false, alive?: true)
    @player = Entity.create(name: 'Fox McCloud', level: 1, xp: 0, health: 100,  location_x: 1, location_y: 1, pc?: true, alive?: true)
    @battle = Battle.new(name: 'Battle!', boss?: false)
    @battle.fetch_entities

  end


  def draw
    draw_quad(1, 1, 0xffffffff, WIDTH, 1, 0xffffffff, WIDTH, HEIGHT, 0xffff0000, 1, HEIGHT, 0xffff0000, 0)
    @player_image.draw(100, 100, 1)
    @vs_image.draw(750, 300, 1)
    @monster_image.draw(1050, 275, 1)

    @font.draw("  NAME: #{@player.name}", 200, 750, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("HEALTH: #{@player.health}", 200, 800, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("  LEVEL: #{@player.level}", 200, 850, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("     XP: #{@player.xp}", 200, 900, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)

    @font.draw("  NAME: #{@player.name}", 1100, 750, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("HEALTH: #{@monster.health}", 1100, 800, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("  LEVEL: #{@monster.level}", 1100, 850, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("     XP: #{@monster.xp}", 1100, 900, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)

    @font.draw("(A)TTACK!", 150, 1000, 2, scale_x = 5, scale_y = 5, color = 0xff_ffffff)
    @font.draw("(F)LEE!", 1075, 1000, 2, scale_x = 5, scale_y = 5, color = 0xff_ffffff)
  end

  def update
    # while @battle.active?
      if button_down? Gosu::KbA then
  #      self.attack
         @player_attack_sound.play
  #       @monster_attack_sound.play
          @battle.attack(@player, @monster)
          @battle.attack(@monster, @player)
#          @battle.fetch_entities
      end
      if button_down? Gosu::KbF then
  #      self.flee
         @player_flee_sound.play
         @battle.flee
      end
    # end
  end

  # def attack
  #   @player_attack_sound.play
  #   @monster_attack_sound.play
  #   #battle.attack(attacker,target)
  #   #return to attack
  # end
  #
  # def flee
  #   @player_flee_sound.play
  #   #battle.flee
  #   #return to map view
  #   #trigger damage?
  # end

end
