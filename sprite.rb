require 'world_object'

class Sprite < WorldObject
  attr_accessor :step
  def initialize win, w, h, d, x, z, image, cols, rows, step
    @step = step
    @cols = cols
    @rows = rows
    @step_off = 0
    @images = Gosu::Image.load_tiles(win, image, -cols, -rows, false)
    @directions = OpenStruct.new :x => :left, :z => :down
    @xstep = @zstep = 0
    super win, w, h, d, x, z
  end
  
  def draw
    clear = Gosu::Color::WHITE

    window.draw_quad(
      screen_x(@x-width/2.0, @z), screen_y(height, @z), clear,
      screen_x(@x+width/2.0, @z), screen_y(height, @z), clear,
      screen_x(@x-width/2.0, @z), screen_y(0, @z), clear,
      screen_x(@x+width/2.0, @z), screen_y(0, @z), clear, @z)

    image.draw_as_quad(
      screen_x(@x-width/2.0, @z), screen_y(height, @z), clear,
      screen_x(@x+width/2.0, @z), screen_y(height, @z), clear,
      screen_x(@x-width/2.0, @z), screen_y(0, @z), clear,
      screen_x(@x+width/2.0, @z), screen_y(0, @z), clear, @z)
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
      @step_off = (@step_off + 1) % @cols
      @start_moving = Time.now
    end
  end

  def set_dest dest_x, dest_z
    @dest_x = dest_x
    @dest_z = dest_z
    dz = (@dest_z-@z).abs
    dx = (@dest_x-@x).abs
    @zstep = dz/(dz+dx)*step
    @xstep = dx/(dz+dx)*step
    @moving_x = @moving_z = true

    printf "x:  %8.3f, dest_x: %8.3f, z:  %8.3f, dest_z: %8.3f\n", @x, @dest_x, @z, @dest_z
    printf "dx: %8.3f, xstep:  %8.3f, dz: %8.3f, zstep:  %8.3f\n\n", dx, @xstep, dz, @zstep
  end

  private
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

      @xstep > (@zstep * 1.5) ? @directions.x : @directions.z
    end

    def image
      case direction
      when :down 
        @images[0+@step_off]
      when :up 
        @images[2+@step_off]
      when :right 
        @images[4+@step_off]
      else
        @images[6+@step_off]
      end
    end
end
