module Screen
  SWIDTH = 1024
  SHEIGHT = 768
  RATIO = SWIDTH/SHEIGHT.to_f
  FOV_X = 45 * Math::PI/180
  FOV_Y = FOV_X/RATIO
  HORIZON = 0.1 # Somewhat misnamed, but this is the closest we'll allow screen y-coords to get to height/2
  ZMIN = SWIDTH/2.0/Math.tan(FOV_X/2.0)
  ZMAX = (SHEIGHT/2.0)*ZMIN / HORIZON

  def screen_x wx, wz
    wx*ZMIN/wz + SWIDTH/2.0
  end

  def screen_y wy, wz
    SHEIGHT/2.0 - ((wy-SHEIGHT/2.0)*ZMIN/wz)
  end

  def world_x sx, sy, wy=0
    (sx-SWIDTH/2.0)*(wy-SHEIGHT/2.0) / (SHEIGHT/2.0 - sy)
  end

  def world_z sy, wy=0
    (wy-SHEIGHT/2.0)*ZMIN / (SHEIGHT/2.0 - sy)
  end
end
