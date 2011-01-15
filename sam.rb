require 'gosu'

class Sam < Gosu::Window
  STEP = 5
  CHAR_HT = 50
  def initialize
    super 1024, 768, false
    @x = @y = @z = 0
  end

  def needs_cursor?() true end

  def button_down key
    case key
    when Gosu::KbEscape
      close
    when Gosu::KbLeft
      @left = true
    when Gosu::KbRight
      @right = true
    when Gosu::KbUp
      @up = true
    when Gosu::KbDown
      @down = true
    end
  end

  def button_up key
    case key
    when Gosu::KbLeft
      @left = false
    when Gosu::KbRight
      @right = false
    when Gosu::KbUp
      @up = false
    when Gosu::KbDown
      @down = false
    end
  end

  def update
    @x += STEP if @right
    @x -= STEP if @left
    @z -= STEP if @up
    @z += STEP if @down

    puts "x: #@x, y: #@y, z: #@z"
  end

  def screen_x offset=0
    @x + offset + width/2.0
  end

  def screen_y offset=0
    height - @y - offset
  end

  def screen_z offset=0
    @z + offset
  end

  def draw
    c = Gosu::Color::RED
    draw_triangle(
      screen_x, screen_y, c,
      screen_x(CHAR_HT), screen_y, c,
      screen_x(CHAR_HT/2), screen_y(CHAR_HT), c)
  end
end
