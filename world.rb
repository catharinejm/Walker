require 'gosu'
require 'ostruct'
require 'screen'
require 'world_object'
require 'sprite'

class World < Gosu::Window
  include Screen
  def initialize
    super SWIDTH, SHEIGHT, false

    @character = Sprite.new(self, 300, 300, 300, 0, 0, "Hiro", "player.png", 2, 4, 10)
    @objects = [WorldObject.new(self, 100, 100, 100, 400, 400, "Cube"),
                WorldObject.new(self, 200, 200, 200, -300, 150, "Flumbert")]
  end

  def needs_cursor?() true end

  def button_down key
    case key
    when Gosu::KbEscape
      close
    when Gosu::MsLeft
      y = mouse_y
      y = height/2.0+0.1 if y <= height/2.0

      @character.set_dest(world_x(mouse_x, y), world_z(y))
    end
    @start_moving = Time.now
  end

  def button_up key
  end

  def update
    @character.update
    @text = Gosu::Image.from_text(self, "x: #{mouse_x}, y: #{mouse_y}", "monaco", 36)
    over = @objects.find { |o| o.contains? mouse_x, mouse_y }
    over ||= @character if @character.contains? mouse_x, mouse_y
    text = (over && over.name) || ''
    @hover_text = Gosu::Image.from_text(self, text, "monaco", 36)
  end

  def draw
    b = Gosu::Color::BLUE
    draw_quad(0, height, b, width, height, b, 0, height/2.0, b, width, height/2.0, b)
    @character.draw
    @objects.each(&:draw)
    @text.draw(0, 0, 0)
    @hover_text.draw(0, 40, 0)
  end
end
