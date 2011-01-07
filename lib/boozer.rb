require 'boozer/game'

module Boozer
  def self.run
    game_window = Boozer::Window.new
    game_window.show
  end
end
