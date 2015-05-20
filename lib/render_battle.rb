require 'gosu'
require 'pry'
require 'sinatra/activerecord'
require 'pg'

require('./lib/battle')
require('./lib/entity')
require './lib/weapon'

WIDTH = 1600
HEIGHT = 1280
DELAY = 200

class BattleWindow < Gosu::Window
  def initialize
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
    @countdown = 0

#temporary entity/battle creation
    @monster = Entity.create(name: 'Gojira', str: 100, level: 1, xp: 0, health: 100,  location_x: 1, location_y: 1, pc?: false, alive?: true)
    @player = Entity.create(name: 'Fox McCloud', str: 15, level: 1, xp: 0, health: 100,  location_x: 1, location_y: 1, pc?: true, alive?: true)
    @weapon = Weapon.generate_random('sword')
    @player.weapons.push(@weapon)
    @battle = Battle.create(name: 'Battle!', boss?: false, active?: true)
    @battle.fetch_entities
binding.pry
  end


  def draw
    draw_quad(1, 1, 0xffffffff, WIDTH, 1, 0xffffffff, WIDTH, HEIGHT, 0xffff0000, 1, HEIGHT, 0xffff0000, 0)
    @player_image.draw(150, 150, 1, scale_x = 0.75, scale_y = 0.75)
    @vs_image.draw(750, 300, 1)
    @monster_image.draw(1050, 175, 1, scale_x = 1.25, scale_y = 1.25)

    @font.draw("NAME: #{@player.name}", 150, 800, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("HEALTH: #{@player.health}", 200, 850, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("  LEVEL: #{@player.level}", 200, 900, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("     XP: #{@player.xp}", 200, 950, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)

    @font.draw("NAME: #{@monster.name}", 1050, 800, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("HEALTH: #{@monster.health}", 1100, 850, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("  LEVEL: #{@monster.level}", 1100, 900, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    @font.draw("     XP: #{@monster.xp}", 1100, 950, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)

    if @countdown/60 > 0
      @font.draw("Chill #{@countdown/60} second(s)", 600, 750, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    end
    if @monster.alive? && @player.alive?
      @font.draw("ALIVE", 250, 1000, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("ALIVE", 1150, 1000, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    end
    # @monster.update(alive?: false)
    # @player.update(alive?: false)
    if !(@monster.alive?) && !(@player.alive?)
      @font.draw("Mutually Assured Destruction, Baby!", 450, 700, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("DEAD", 250, 1000, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("DEAD", 1150, 1000, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    end
    #@monster.update(alive?: false)
    if !(@monster.alive?) && @player.alive?
      @font.draw("Total Monster DESTRUCTION!", 450, 700, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("ALIVE", 250, 1000, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("DEAD", 1150, 1000, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    end
    @player.update(alive?: false)
    if !(@player.alive?) && @monster.alive?
      @font.draw("Adieu, mon ami!", 600, 675, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("As vee zay in France, don' layt yo petite frog-legs gayt zo cloze to zee butterr.", 225, 725, 2, scale_x = 2, scale_y = 3, color = 0xff_ffffff)
      @font.draw("DEAD", 250, 1000, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
      @font.draw("ALIVE", 1150, 1000, 2, scale_x = 3, scale_y = 3, color = 0xff_ffffff)
    end

    @font.draw(" (A)TTACK!", 150, 1100, 2, scale_x = 5, scale_y = 5, color = 0xff_ffffff)
    @font.draw(" (F)LEE!", 1075, 1100, 2, scale_x = 5, scale_y = 5, color = 0xff_ffffff)
  end

  def update
    # while @battle.active?
      if @countdown > 0 then
        @countdown -= 1
      end
      if (button_down? Gosu::KbA) && @battle.active? && @monster.alive? && @player.alive? then
  #     self.attack
        if @countdown == 0
  #        @player_attack_sound.play
           @countdown = DELAY
           @monster_attack_sound.play
  #         @battle.attack(@player, @monster)
  #         @battle.attack(@monster, @player)
        end
      end
      if (button_down? Gosu::KbF) && @battle.active? then
  #      self.flee
         @player_flee_sound.play
         @countdown = DELAY
         @battle.flee
      end
    # end
    if !(@battle.active?) then
      @player.name = "QUITTER"
      @monster.name = "PROXY WINNER"
    end
  end

  # def attack
  #   @player_attack_sound.play
  #   @monster_attack_sound.play
  #   #battle.attack(attacker,target)
  #   #return to attack
  # end

  # def flee
  #   @player_flee_sound.play
  #   #battle.flee
  #   #return to map view
  #   #trigger damage?
  # end

end
