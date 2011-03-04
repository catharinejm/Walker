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
    @destinations = []
  end
  
  def draw
    clear = Gosu::Color::WHITE

    window.draw_quad(
      screen_x(left, front), screen_y(0, front), clear,
      screen_x(right, front), screen_y(0, front), clear,
      screen_x(left, back), screen_y(0, back), clear,
      screen_x(right, back), screen_y(0, back), clear, z_index)

    unless $__debug_mode__
      image.draw_as_quad(
        screen_x(left, @z), screen_y(height, @z), clear,
        screen_x(right, @z), screen_y(height, @z), clear,
        screen_x(left, @z), screen_y(0, @z), clear,
        screen_x(right, @z), screen_y(0, @z), clear, z_index)
    end

    c = Gosu::Color::GREEN
    stx, stz = [@x, @z]
    ([[@dest_x, @dest_z]] + @destinations).each do |dx, dz|
      window.draw_quad(
        screen_x(dx-5, dz-5), screen_y(0, dz-5), c,
        screen_x(dx+5, dz-5), screen_y(0, dz-5), c,
        screen_x(dx-5, dz+5), screen_y(0, dz+5), c,
        screen_x(dx+5, dz+5), screen_y(0, dz+5), c, ZMAX)
      window.draw_line(
        screen_x(stx, stz), screen_y(0, stz), c,
        screen_x(dx, dz), screen_y(0, dz), c, ZMAX)
      stx, stz = [dx, dz]
    end
  end

  def update
    if (@dest_x - @x).abs <= @xstep
      @x = @dest_x
      @moving_x = false
    elsif @x < @dest_x
      @x += @xstep
    elsif @x > @dest_x
      @x -= @xstep
    end
    if (@dest_z - @z).abs <= @zstep
      @z = @dest_z
      @moving_z = false
    elsif @z < @dest_z
      @z += @zstep
    elsif @z > @dest_z
      @z -= @zstep
    end

    if (@moving_x || @moving_z) && Time.now.to_f - @start_moving.to_f > 0.3
      @step_off = (@step_off + 1) % @cols
      @start_moving = Time.now
    end
    
    set_dest!
  end

  def register_click mouse_x, mouse_y, objects
    x = world_x(mouse_x, mouse_y)
    z = world_z(mouse_y)
    if dest_obj = objects.find { |o| o.in_footprint? x, z }
      if dest_obj.padded_left < x && x < dest_obj.left
        x = dest_obj.padded_left-1
      elsif dest_obj.padded_right > x && x > dest_obj.right
        x = dest_obj.padded_right + 1
      end
      if dest_obj.padded_front < z && z < dest_obj.front
        z = dest_obj.padded_front-1
      elsif dest_obj.padded_back > z && z > dest_obj.back
        z = dest_obj.padded_back+1
      end
    end
    @destinations.replace [[x, z]]
    puts "Objects: #{objects.map(&:name).join(', ')}"
    objects.each do |obj|
      stx = @x
      stz = @z
      @destinations.each_with_index do |(dx, dz), idx|
        if obj.on_path? stx, stz, dx, dz
          debugger if $__debug_mode__ && @destinations.size > objects.size*4+1
          puts "intersecting #{obj.name}"
          stx, stz = obj.nearest_corner stx, stz, dx, dz
          @destinations.insert idx, [stx, stz]
        else
          stx = dx
          stz = dz
        end
      end
    end
    @moving_x = @moving_z = false
    set_dest!
  end

  def set_dest!
    return if @moving_x || @moving_z || @destinations.empty?
    puts "Setting destination!"
    @dest_x, @dest_z = @destinations.shift
    dz = (@dest_z-@z).abs
    dx = (@dest_x-@x).abs
    if (dx+dz).zero?
      @zstep = @xstep = 0
    else
      @zstep = dz/(dz+dx)*step
      @xstep = dx/(dz+dx)*step
      @moving_x = @moving_z = true
    end

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
