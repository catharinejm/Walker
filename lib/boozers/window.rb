module Boozers
  class Window < Gosu::Window
    def initialize
      super 640, 480, false
      @triangles = []
    end

    def needs_cursor?() true end

    def button_down id
      case id 
      when Gosu::KbEscape
        @exiting = true
        puts "Exiting..."
        close
      when Gosu::MsLeft
        @triangles << [mouse_x, mouse_y, Gosu::Color::RED]
        @down_time = Time.now
        puts "#{mouse_x}, #{mouse_y}"
      end
    end

    def button_up id
      if id == Gosu::MsLeft
        @triangles << [mouse_x, mouse_y, Gosu::Color::BLUE]
        puts "Held for: #{Time.now - @down_time}"
      end
    end

    def update
    end
    
    def draw
      @triangles.each do |(x, y, c)|
        draw_triangle x-30, y+30, c, x+30, y+30, c, x, y-30, c
      end
    end
  end
end
