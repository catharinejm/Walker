require 'matrix'

module GoAround
  def side_intx(stx, stz, edx, edz, side)
    # p stx, stz, edx, edz, side
    return nil unless [stx, side, edx].sort[1] == side || in_footprint?(edx, edz)
    pz_nmr =
      Matrix[
        [Matrix[[stx,stz],[edx,edz]].det, Matrix[[stz,1],[edz,1]].det],
        [Matrix[[side,padded_back],[side,padded_front]].det, Matrix[[padded_back,1],[padded_front,1]].det]
      ].det
    denom =
      Matrix[
        [Matrix[[stx,1],[edx,1]].det, Matrix[[stz,1],[edz,1]].det],
        [Matrix[[side,1],[side,1]].det, Matrix[[padded_back,1],[padded_front,1]].det]
      ].det

    pz = pz_nmr/denom
    pz <= padded_back && pz >= padded_front ? [side, pz] : nil
  end

  def left_intx(stx, stz, edx, edz)
    side_intx(stx, stz, edx, edz, padded_left)
  end

  def right_intx(stx, stz, edx, edz)
    side_intx(stx, stz, edx, edz, padded_right)
  end

  def fb_intx(stx, stz, edx, edz, fb)
    # p stx, stz, edx, edz, fb
    return nil unless [stz, fb, edz].sort[1] == fb || in_footprint?(edx, edz)
    px_nmr =
      Matrix[
        [Matrix[[stx,stz],[edx,edz]].det, Matrix[[stx,1],[edx,1]].det],
        [Matrix[[padded_left,fb],[padded_right,fb]].det, Matrix[[padded_left,1],[padded_right,1]].det]
      ].det
    denom =
      Matrix[
        [Matrix[[stx,1],[edx,1]].det, Matrix[[stz,1],[edz,1]].det],
        [Matrix[[padded_left,1],[padded_right,1]].det, Matrix[[fb,1],[fb,1]].det]
      ].det

    px = px_nmr/denom
    px >= padded_left && px <= padded_right ? [px, fb] : nil
  end

  def back_intx(stx, stz, edx, edz)
    fb_intx(stx, stz, edx, edz, padded_back)
  end

  def front_intx(stx, stz, edx, edz)
    fb_intx(stx, stz, edx, edz, padded_front)
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
    fi = front_intx(stx, stz, edx, edz)

    if li
      if ri
        x = stx < edx ? padded_left-1 : padded_right+1
        z = edz < @z ? padded_front-1 : padded_back+1
      else
        x = padded_left-1
        z = fi ? padded_front-1 : padded_back+1
      end
    elsif ri
      x = padded_right+1
      z = fi ? padded_front-1 : padded_back+1
    else
      x = edx < @x ? padded_left-1 : padded_right+1
      z = stz < edz ? padded_front-1 : padded_back+1
    end

    [x, z]
  rescue
    if $__debug_mode__
      debugger
      retry
    else
      raise
    end
  end
end
