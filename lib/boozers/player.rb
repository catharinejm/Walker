module Boozers
  class Player
    attr_reader :x, :y, :height, :color

    def initialize x, y, color
      @x = x
      @y = y
      @color = color
      @vx = @vy = 0
      @height = 10
    end

    def move_to x, y
      @end_x = x
      @end_y = y

      speed = 3

      total_distance = Math.sqrt((@end_x - @x)**2 + (@end_y - @y)**2)


    end

    def move_to x, y
      @end_x = x
      @end_y = y

      @delta_x = @end_x - @x
      @delta_y = @end_y - @y

      m = @delta_y / @delta_x

      if Math.abs(@delta_x) > Math.abs(@delta_y)
        
      else
      end

      puts "end_x: #@end_x, end_y: #@end_y, vx: #@vx, vy: #@vy"
    end

    def tick!
      @x += @vx unless at_x?
      @y += @vy unless at_y?
    end

    private

      def at_x?
        if @end_x.nil? || @vx.zero?
          true
        elsif @vx > 0
          @x >= @end_x
        else
          @x <= @end_x
        end
      end

      def at_y?
        if @end_y.nil? || @vy.zero?
          true
        elsif @vy > 0
          @y >= @end_y
        else
          @y <= @end_y
        end
      end
  end
end
