require 'world_object'

class Sprite < WorldObject
  def initialize win, w, h, d, x, z, image, rows, cols
    @images = Gosu::Image.load_tiles(image, -rows, -cols)
    super win, w, h, d, x, z
  end
  
  def foobarbazquux
  end
end
