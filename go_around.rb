require 'matrix'

module GoAround
  def side_intx(stx, stz, edx, edz, side)
    # p stx, stz, edx, edz, side
    return nil unless [stx, side, edx].sort[1] == side
    pz_nmr =
      Matrix[
        [Matrix[[stx,stz],[edx,edz]].det, Matrix[[stz,1],[edz,1]].det],
        [Matrix[[side,back],[side,front]].det, Matrix[[back,1],[front,1]].det]
      ].det
    denom =
      Matrix[
        [Matrix[[stx,1],[edx,1]].det, Matrix[[stz,1],[edz,1]].det],
        [Matrix[[side,1],[side,1]].det, Matrix[[back,1],[front,1]].det]
      ].det

    pz = pz_nmr/denom
    pz >= back && pz <= front ? [side, pz] : nil
  end

  def left_intx(stx, stz, edx, edz)
    side_intx(stx, stz, edx, edz, left)
  end

  def right_intx(stx, stz, edx, edz)
    side_intx(stx, stz, edx, edz, right)
  end

  def fb_intx(stx, stz, edx, edz, fb)
    # p stx, stz, edx, edz, fb
    return nil unless [stz, fb, edz].sort[1] == fb
    px_nmr =
      Matrix[
        [Matrix[[stx,stz],[edx,edz]].det, Matrix[[stx,1],[edx,1]].det],
        [Matrix[[left,fb],[right,fb]].det, Matrix[[left,1],[right,1]].det]
      ].det
    denom =
      Matrix[
        [Matrix[[stx,1],[edx,1]].det, Matrix[[stz,1],[edz,1]].det],
        [Matrix[[left,1],[right,1]].det, Matrix[[fb,1],[fb,1]].det]
      ].det

    px = px_nmr/denom
    px >= left && px <= right ? [px, fb] : nil
  end

  def back_intx(stx, stz, edx, edz)
    fb_intx(stx, stz, edx, edz, back)
  end

  def front_intx(stx, stz, edx, edz)
    fb_intx(stx, stz, edx, edz, front)
  end

  def on_path?(stx, stz, edx, edz)
    left_intx(stx, stz, edx, edz) || 
    right_intx(stx, stz, edx, edz) || 
    back_intx(stx, stz, edx, edz) || 
    front_intx(stx, stz, edx, edz)
  end

  def nearest_corner(stx, stz, edx, edz)
    li = left_intx(stx, stz, edx, edz)
    ri = right_intx(stx, stz, edx, edz)
    bi = back_intx(stx, stz, edx, edz)
    fi = front_intx(stx, stz, edx, edz)
    
    if stx < edx
      if stz < edz
        x, z = bi || li
      else
        x, z = fi || li
      end
    else
      if stz < edz
        x, z = bi || ri
      else
        x, z = fi || ri
      end
    end
    x = x > @x ? right+1 : left-1
    z = z > @z ? front+1 : back-1

    if stx == x && stz == z
      if x == left-1
        if z == back-1
          if fi
            z = front+1
          else
            x = right+1
          end
        else
          if bi
            z = back-1
          else
            x = right+1
          end
        end
      else
        if z == back-1
          if fi
            z = front+1
          else
            x = left-1
          end
        else
          if bi
            z = back-1
          else
            x = left-1
          end
        end
      end
    end
    [x, z]
  end
end
