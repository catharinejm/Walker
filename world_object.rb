class WorldObject
  attr_accessor :width, :height, :depth, :x, :y, :z
  include Screen
  attr_reader :window
  def initialize window, width, height, depth, x, z
    @window = window
    @width = width
    @height = height
    @depth = depth
    @x = x
    @z = z + ZMIN
  end

  def screen_x(*args) window.screen_x(*args) end
  def screen_y(*args) window.screen_y(*args) end

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
