module Screen
  SWIDTH = 1024
  SHEIGHT = 768
  RATIO = SWIDTH/SHEIGHT.to_f
  FOV_X = 80 * Math::PI/180
  FOV_Y = FOV_X/RATIO
  ZMIN = SWIDTH/2.0/Math.tan(FOV_X/2.0)

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
end
