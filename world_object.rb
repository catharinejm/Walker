require 'screen'

class WorldObject
  include Screen
  attr_accessor :width, :height, :depth, :x, :z, :name
  attr_reader :window
  def initialize window, width, height, depth, x, z, name
    @window = window
    @width = width
    @height = height
    @depth = depth
    @x = x
    @z = z + ZMIN
    @name = name
  end

  def front
    z - depth/2.0
  end

  def back
    z + depth/2.0
  end

  def left
    x - width/2.0
  end

  def right
    x + width/2.0
  end

  def contains? x, y
    (left..right).cover?(world_x(x, y)) && (front..back).cover?(world_z(y))
  end

  def draw
    red = Gosu::Color::RED
    green = Gosu::Color::GREEN
    yellow = Gosu::Color::YELLOW

    # Front
    window.draw_quad(
      screen_x(left, front), screen_y(0, front), red,
      screen_x(right, front), screen_y(0, front), red,
      screen_x(left, front), screen_y(height, front), red,
      screen_x(right, front), screen_y(height, front), red)

    # Top
    window.draw_quad(
      screen_x(left, front), screen_y(height, front), green,
      screen_x(right, front), screen_y(height, front), green,
      screen_x(left, back), screen_y(height, back), green,
      screen_x(right, back), screen_y(height, back), green)

    if x < 0
      window.draw_quad(
        screen_x(right, front), screen_y(0, front), yellow,
        screen_x(right, back), screen_y(0, back), yellow,
        screen_x(right, front), screen_y(height, front), yellow,
        screen_x(right, back), screen_y(height, back), yellow)
    elsif x > 0
      window.draw_quad(
        screen_x(left, front), screen_y(0, front), yellow,
        screen_x(left, back), screen_y(0, back), yellow,
        screen_x(left, front), screen_y(height, front), yellow,
        screen_x(left, back), screen_y(height, back), yellow)
    end
  end
end
