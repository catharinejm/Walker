require 'gosu'

class Sam < Gosu::Window
  STEP = 5
  CHAR_HT = 300.0
  SWIDTH = 1024
  SHEIGHT = 768
  RATIO = SWIDTH/SHEIGHT.to_f
  FOV_X = 100 * Math::PI/180
  FOV_Y = FOV_X/RATIO
  ZMIN = SWIDTH/2.0/Math.tan(FOV_X/2.0)

  def initialize
    super SWIDTH, SHEIGHT, false
    @x = @dest_x = 0
    @z = @dest_z = ZMIN

    @images = Gosu::Image.load_tiles(self, "player.png", -2, -4, false)
  end

  def needs_cursor?() true end

  def button_down key
    case key
    when Gosu::KbEscape
      close
    when Gosu::MsLeft
      @dest_x = world_x(mouse_x, mouse_y)
      @dest_z = world_z(mouse_y)
    end
    @start_moving = Time.now
    @step = 0
  end

  def button_up key
  end

  def update
    if @dest_x > @x + STEP
      @x += STEP
    elsif @dest_x < @x - STEP
      @x -= STEP
    elsif (@dest_x - @x).abs < STEP
      @x = @dest_x
    end
    if @dest_z > @z + STEP
      @z += STEP
    elsif @dest_z < @z - STEP
      @z -= STEP
    elsif (@dest_z - @z).abs < STEP
      @z = @dest_z
    end

    @z = ZMIN if @z < ZMIN
    @x = -width/2.0 if @x < -width/2.0
    @x = width/2.0 if @x > width/2.0

    if Time.now.to_f - @start_moving.to_f > 0.2
      @step = @step.to_i + 1 
      @start_moving = Time.now
    end

    puts "x: #@x, z: #@z"
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

  def image
    return @images[6+@step%2] if @left
    return @images[2+@step%2] if @up
    return @images[4+@step%2] if @right
    @images[0+@step%2]
  end

  def draw
    c = Gosu::Color::RED
    b = Gosu::Color::BLUE
    clear = Gosu::Color::WHITE

    draw_quad(
      screen_x(-width/2.0, ZMIN), screen_y(0, ZMIN), b,
      screen_x(width/2.0, ZMIN), screen_y(0, ZMIN), b,
      screen_x(-width/2.0, ZMIN+height/2.0), screen_y(0, ZMIN+height/2.0), b,
      screen_x(width/2.0, ZMIN+height/2.0), screen_y(0, ZMIN+height/2.0), b)

    image.draw_as_quad(
      screen_x(@x-CHAR_HT/2, @z), screen_y(CHAR_HT, @z), clear,
      screen_x(@x+CHAR_HT/2, @z), screen_y(CHAR_HT, @z), clear,
      screen_x(@x-CHAR_HT/2, @z), screen_y(0, @z), clear,
      screen_x(@x+CHAR_HT/2, @z), screen_y(0, @z), clear, @z)
    # draw_triangle(
    #   screen_x(@x-CHAR_HT/2, @z), screen_y(0, @z), c,
    #   screen_x(@x+CHAR_HT/2, @z), screen_y(0, @z), c,
    #   screen_x(@x, @z), screen_y(CHAR_HT, @z), c)
  end
end
