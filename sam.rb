require 'gosu'

class Sam < Gosu::Window
  STEP = 5
  CHAR_HT = 300.0
  SWIDTH = 1024
  SHEIGHT = 768
  ZMIN = 228 # arbitrary? Need to figure out what this is. Or not.
  ZMAX = ZMIN+384
  RATIO = SWIDTH/SHEIGHT.to_f
  FOV_X = 120 * Math::PI/180
  FOV_Y = FOV_X/RATIO

  def initialize
    super SWIDTH, SHEIGHT, false
    @x = 0
    @z = ZMIN
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
    @z += STEP if @up
    @z -= STEP if @down

    @z = ZMIN if @z < ZMIN
    @z = ZMAX if @z > ZMAX
    @x = -width/2.0 if @x < -width/2.0
    @x = width/2.0 if @x > width/2.0

    puts "x: #@x, z: #@z"
  end

  def screen_x x, z
    x * width/2.0/(z*Math.tan(FOV_X/2.0)) + width / 2.0
  end

  def screen_y y, z
    ((height/2.0-y) * height/2.0/(z*Math.tan(FOV_Y/2.0)) + height/2.0)/RATIO
  end

  def draw
    c = Gosu::Color::RED
    b = Gosu::Color::BLUE

    draw_quad(
      screen_x(-512, ZMIN), screen_y(0, ZMIN), b,
      screen_x(512, ZMIN), screen_y(0, ZMIN), b,
      screen_x(-512, ZMAX), screen_y(0, ZMAX), b,
      screen_x(512, ZMAX), screen_y(0, ZMAX), b)
    draw_triangle(
      screen_x(@x-CHAR_HT/2, @z), screen_y(0, @z), c,
      screen_x(@x+CHAR_HT/2, @z), screen_y(0, @z), c,
      screen_x(@x, @z), screen_y(CHAR_HT, @z), c)
  end
end
