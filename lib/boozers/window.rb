module Boozers
  class Window < Gosu::Window
    def initialize
      super 1024, 768, false
      @player = Player.new 0, 0, Gosu::Color::RED
    end

    def needs_cursor?() true end

    def button_down id
      case id 
      when Gosu::KbEscape
        @exiting = true
        puts "Exiting..."
        close
      when Gosu::MsLeft
        @player.move_to(mouse_x, mouse_y)
      end
    end

    def button_up id
    end

    def update
      @player.tick!
    end
    
    def draw
      draw_triangle(@player.x-@player.height, @player.y+@player.height, @player.color,
                    @player.x+@player.height, @player.y+@player.height, @player.color,
                    @player.x, @player.y-@player.height, @player.color)
    end
  end
end
