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

    @images = Gosu::Image.load_tiles(self, "player.png", -2, -4, false)
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
    @start_moving = Time.now
    @step = 0
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

    if Time.now.to_f - @start_moving.to_f > 0.2
      @step = @step.to_i + 1 
      @start_moving = Time.now
    end

    puts "x: #@x, z: #@z"
  end

  def screen_x x, z
    x * width/2.0/(z*Math.tan(FOV_X/2.0)) + width / 2.0
  end

  def screen_y y, z
    ((height/2.0-y) * height/2.0/(z*Math.tan(FOV_Y/2.0)) + height/2.0)/RATIO
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
      screen_x(-512, ZMIN), screen_y(0, ZMIN), b,
      screen_x(512, ZMIN), screen_y(0, ZMIN), b,
      screen_x(-512, ZMAX), screen_y(0, ZMAX), b,
      screen_x(512, ZMAX), screen_y(0, ZMAX), b)

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
