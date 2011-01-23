class WorldObject
  attr_accessor :width, :height, :depth, :x, :y, :z
  def initialize window, width, height, depth, x, z
    @width = width
    @height = height
    @depth = depth
    @x = x
    @z = z + World::ZMIN
  end

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
end
