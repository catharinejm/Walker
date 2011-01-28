require 'world_object'

class Sprite < WorldObject
  attr_accessor :step
  def initialize win, w, h, d, x, z, name, image, cols, rows, step
    @step = step
    @cols = cols
    @rows = rows
    @step_off = 0
    @images = Gosu::Image.load_tiles(win, image, -cols, -rows, false)
    @directions = OpenStruct.new :x => :left, :z => :down
    @xstep = @zstep = 0
    super win, w, h, d, x, z, name
    @dest_x = @x
    @dest_z = @z
  end
  
  def draw
    clear = Gosu::Color::WHITE

    window.draw_quad(
      screen_x(left, front), screen_y(0, front), clear,
      screen_x(right, front), screen_y(0, front), clear,
      screen_x(left, back), screen_y(0, back), clear,
      screen_x(right, back), screen_y(0, back), clear, z_index)

    image.draw_as_quad(
      screen_x(left, @z), screen_y(height, @z), clear,
      screen_x(right, @z), screen_y(height, @z), clear,
      screen_x(left, @z), screen_y(0, @z), clear,
      screen_x(right, @z), screen_y(0, @z), clear, z_index)
  end

  def moving_left?()  @dest_x < @x end
  def moving_right?()  @dest_x > @x end
  def moving_back?() @dest_z > @z end
  def moving_forward?() @dest_z < @x end

  def moving?
    @dest_x != @x || @dest_z != @z
  end

  def update
    if (@dest_x - @x).abs <= @xstep
      @x = @dest_x
    elsif moving_right?
      @x += @xstep
    elsif moving_left?
      @x -= @xstep
    end
    if (@dest_z - @z).abs <= @zstep
      @z = @dest_z
    elsif moving_back?
      @z += @zstep
    elsif moving_forward?
      @z -= @zstep
    end

    if moving? && Time.now.to_f - @start_moving.to_f > 0.3
      @step_off = (@step_off + 1) % @cols
      @start_moving = Time.now
    end
  end

  def set_dest dest_x, dest_z, dest_obj
    if dest_obj && dest_obj.contains?(dest_x, dest_z)
      if @x < dest_x
        if @x < dest_obj.left
          @dest_x = dest_obj.left
        else
          @dest_x = dest_obj.x
        end
      elsif @x > dest_x
        if @x > dest_obj.right
          @dest_x = dest_obj.right
        else
          @dest_x = dest_obj.x
        end
      end
      if @z < dest_z
        if @z < dest_obj.front
          @dest_z = dest_obj.front
        else
          @dest_z = dest_obj.z
        end
      elsif @z > dest_z
        if @z > dest_obj.back
          @dest_z = dest_obj.back
        else
          @dest_z = dest_obj.z
        end
      end
    else
      @dest_x = dest_x
      @dest_z = dest_z
    end

    dz = (@dest_z-@z).abs
    dx = (@dest_x-@x).abs
    @zstep = dz/(dz+dx)*step
    @xstep = dx/(dz+dx)*step

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
