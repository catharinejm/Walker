require 'gosu'
require 'ostruct'

class Sam < Gosu::Window
  STEP = 5
  CHAR_HT = 300.0
  SWIDTH = 1024
  SHEIGHT = 768
  RATIO = SWIDTH/SHEIGHT.to_f
  FOV_X = 80 * Math::PI/180
  FOV_Y = FOV_X/RATIO
  ZMIN = SWIDTH/2.0/Math.tan(FOV_X/2.0)

  def initialize
    super SWIDTH, SHEIGHT, false
    @x = @dest_x = 0
    @z = @dest_z = ZMIN
    @xstep = @zstep = 0
    @directions = OpenStruct.new :x => :left, :z => :down

    @images = Gosu::Image.load_tiles(self, "player.png", -2, -4, false)
  end

  def needs_cursor?() true end

  def button_down key
    case key
    when Gosu::KbEscape
      close
    when Gosu::MsLeft
      y = mouse_y
      y = height/2.0+0.1 if y <= height/2.0
      @dest_x = world_x(mouse_x, y)
      @dest_z = world_z(y)

      @dest_x = -width/2.0 if @dest_x < -width/2.0
      @dest_x = width/2.0 if @dest_x > width/2.0
      @dest_z = ZMIN if @dest_z < ZMIN
      @dest_z = ZMIN+512 if @dest_z > ZMIN+512

      dz = (@dest_z-@z).abs
      dx = (@dest_x-@x).abs
      @zstep = dz/(dz+dx)*STEP
      @xstep = dx/(dz+dx)*STEP

      @moving_x = true
      @moving_z = true

      printf "x:  %8.3f, dest_x: %8.3f, z:  %8.3f, dest_z: %8.3f\n", @x, @dest_x, @z, @dest_z
      printf "dx: %8.3f, xstep:  %8.3f, dz: %8.3f, zstep:  %8.3f\n\n", dx, @xstep, dz, @zstep
    end
    @start_moving = Time.now
    @step = 0
  end

  def button_up key
  end

  def update
    if (@dest_x - @x).abs <= @xstep
      @x = @dest_x
      @moving_x = false
    elsif @dest_x > @x
      @x += @xstep
    elsif @dest_x < @x
      @x -= @xstep
    end
    if (@dest_z - @z).abs <= @zstep
      @z = @dest_z
      @moving_z = false
    elsif @dest_z > @z
      @z += @zstep
    elsif @dest_z < @z
      @z -= @zstep
    end

    if (@moving_x || @moving_z) && Time.now.to_f - @start_moving.to_f > 0.3
      @step = !@step
      @start_moving = Time.now
    end

    # puts "x: #@x, dest_x: #@dest_x, z: #@z, dest_z: #@dest_z"
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

  def direction
    if @dest_x < @x
      @directions.x = :left
    elsif @dest_x > @x
      @directions.x = :right
    end

    if @dest_z < @z
      @directions.z = :down
    elsif @dest_z > @z
      @directions.z = :up
    end

    @xstep > (@zstep * 2) ? @directions.x : @directions.z
  end

  def image
    case direction
    when :left 
      @images[6+(@step ? 1 : 0)]
    when :up 
      @images[2+(@step ? 1 : 0)]
    when :right 
      @images[4+(@step ? 1 : 0)]
    else
      @images[0+(@step ? 1 : 0)]
    end
  end

  def draw
    c = Gosu::Color::RED
    b = Gosu::Color::BLUE
    clear = Gosu::Color::WHITE

    draw_quad(
      screen_x(-width/2.0, ZMIN), screen_y(0, ZMIN), b,
      screen_x(width/2.0, ZMIN), screen_y(0, ZMIN), b,
      screen_x(-width/2.0, ZMIN+512), screen_y(0, ZMIN+512), b,
      screen_x(width/2.0, ZMIN+512), screen_y(0, ZMIN+512), b)

    image.draw_as_quad(
      screen_x(@x-CHAR_HT/2, @z), screen_y(CHAR_HT, @z), clear,
      screen_x(@x+CHAR_HT/2, @z), screen_y(CHAR_HT, @z), clear,
      screen_x(@x-CHAR_HT/2, @z), screen_y(0, @z), clear,
      screen_x(@x+CHAR_HT/2, @z), screen_y(0, @z), clear, 0)
    # draw_triangle(
    #   screen_x(@x-CHAR_HT/2, @z), screen_y(0, @z), c,
    #   screen_x(@x+CHAR_HT/2, @z), screen_y(0, @z), c,
    #   screen_x(@x, @z), screen_y(CHAR_HT, @z), c)
  end
end
