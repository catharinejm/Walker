require 'gosu'
require 'ostruct'
require 'world_object'
require 'sprite'

class World < Gosu::Window
  CHAR_HT = 300.0
  SWIDTH = 1024
  SHEIGHT = 768
  RATIO = SWIDTH/SHEIGHT.to_f
  FOV_X = 80 * Math::PI/180
  FOV_Y = FOV_X/RATIO
  ZMIN = SWIDTH/2.0/Math.tan(FOV_X/2.0)

  def initialize
    super SWIDTH, SHEIGHT, false

    @character = Sprite.new(self, 300, 300, 300, 0, 0, "player.png", 2, 4, 10)
    @objects = [WorldObject.new(self, 100, 100, 100, 400, 400)]
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
  end

  def screen_x wx, wz
    wx*ZMIN/wz + width/2.0
  end

  def screen_y wy, wz
    height/2.0 - ((wy-height/2.0)*ZMIN/wz)
  end

  def world_x sx, sy, wy=0
    (sx-width/2.0)*(wy-height/2.0) / (height/2.0 - sy)
  end

  def world_z sy, wy=0
    (wy-height/2.0)*ZMIN / (height/2.0 - sy)
  end

  def draw
    b = Gosu::Color::BLUE
    draw_quad(0, height, b, width, height, b, 0, height/2.0, b, width, height/2.0, b)
    @character.draw
    @objects.each(&:draw)
  end
end
