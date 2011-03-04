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
    @objects = [WorldObject.new(self, 100, 100, 100, 400, 400, "Cube", 150),
                WorldObject.new(self, 200, 200, 200, -300, 150, "Flumbert", 150)]
  end

  def needs_cursor?() true end

  def button_down key
    case key
    when Gosu::KbEscape, Gosu::KbQ
      close
    when Gosu::KbD
      require 'ruby-debug'
      $__debug_mode__ = !$__debug_mode__
    when Gosu::MsLeft
      y = mouse_y
      y = height/2.0+HORIZON if y <= height/2.0

      @character.register_click mouse_x, y, @objects
    end
    @start_moving = Time.now
  end

  def button_up key
  end

  def obj_under_mouse
    @obj_under_mouse ||= @objects.find { |o| o.contains? mouse_x, mouse_y }
  end

  def update
    @character.update
    @text = Gosu::Image.from_text(self, "x: #{mouse_x}, y: #{mouse_y}", "monaco", 36)
    over = obj_under_mouse 
    over ||= @character if @character.contains? mouse_x, mouse_y
    text = (over && over.name) || ''
    @hover_text = Gosu::Image.from_text(self, text, "monaco", 36)
    @obj_under_mouse = nil
  end

  def draw
    b = Gosu::Color::BLUE
    draw_quad(0, height, b, width, height, b, 0, height/2.0, b, width, height/2.0, b)
    @character.draw
    @objects.each(&:draw)
    @text.draw(0, 0, 0)
    @hover_text.draw(0, 40, 0)
    Gosu::Image.from_text(self, "DEBUG", "monaco", 36).draw(width-100, 0, 0) if $__debug_mode__
  end
end
