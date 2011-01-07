require 'gosu'

class Perspective < Gosu::Window
  def initialize
    super 1024, 768, false
  end

  def needs_cursor?() true end

  def button_down key
    if key == Gosu::KbEscape
      puts 'Exiting...'
      close
    end
  end

  def draw
    c = Gosu::Color::BLUE
    th = Math::PI/36
    print "> "
    y_delt = gets.strip.to_i
    x_delt = y_delt/Math.tan(th)
    draw_quad(
      0, 768, c,
      1024, 768, c,
      1024-x_delt, 768-y_delt, c,
      x_delt, 768-y_delt, c)
  end
end
