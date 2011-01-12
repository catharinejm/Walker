require 'gosu'

class Perspective < Gosu::Window
  def initialize
    super 1024, 768, false
    @x = 0
    @y = 768
    @z = 300
  end

  def needs_cursor?() true end

  def button_down key
    case key
    when Gosu::KbEscape
      puts 'Exiting...'
      close
    when Gosu::KbUp
      @up = true
    when Gosu::KbDown
      @down = true
    when Gosu::KbLeft
      @left = true
    when Gosu::KbRight
      @right = true
    end
    @show=true
  end

  def button_up key
    case key
    when Gosu::KbUp
      @up = false
    when Gosu::KbDown
      @down = false
    when Gosu::KbLeft
      @left = false
    when Gosu::KbRight
      @right = false
    end
    @show = false
  end

  def update
    if @up
      if @x + @z / 2 < 512
        @x += @y / 64 * (512 - @x + 768 - @y) / 512
      elsif @x + @z / 2 > 512
        @x -= @y / 64 * (@x - 512 + 768 - @y) / 512
      end
      @y -= @y / 64
      @z -= @z / 32
    end
    if @down
      if @x + @z / 2 > 512
        @x += @y / 64 * (@x - 512 + 768 - @y) / 512
      elsif @x + @z / 2 < 512
        @x -= @y / 64 * (512 - @x + 768 - @y) / 512
      end
      @y += @y / 64
      @z += @z / 32
    end
    if @left
      @x -= 10 * (@y - 256) / 512.0
    end
    if @right
      @x += 10 * (@y - 256) / 512.0
    end
  end

  def draw
    draw_floor
    draw_dude
  end

  def draw_dude
    puts "x: #@x, y: #@y, z: #@z" if @show
    red = Gosu::Color::RED
    draw_triangle(
      @x, @y, red,
      @x+@z, @y, red,
      @x+@z/2, @y-@z, red)
  end

  def draw_floor
    blue = Gosu::Color::BLUE
    draw_quad(
      0, 768, blue,
      256, 512, blue,
      768, 512, blue,
      1024, 768, blue)
  end
end
