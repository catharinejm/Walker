module Boozers
  class Game

    def initialize
      @window = Window.new
      @player = Player.new
    end

    def start
      @window.show
    end

  end
end
