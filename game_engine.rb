require 'gosu'
require './lib/render_world'
require './lib/render_battle'

while #something is true
  if true#not in a battle
    window = WorldWindow.new
  else
    window = BattleWindow.new
  end
window.show
end
