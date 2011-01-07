require 'boozers/game'

module Boozers
  def self.run
    game_window = Boozers::Window.new
    game_window.show
  end
end
