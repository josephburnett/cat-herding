pico-8 cartridge // http://www.pico-8.com
version 15
__lua__

x = 64  y = 64
a = 10  b = 10

function _update()
   if (btn(0)) then x=x-1 end
   if (btn(1)) then x=x+1 end
   if (btn(2)) then y=y-1 end
   if (btn(3)) then y=y+1 end
   move_away()
   x = limit(x)
   y = limit(y)
   a = limit(a)
   b = limit(b)
end

function _draw()
   rectfill(0,0,127,127,5)
   circfill(x,y,2,8)
   circfill(a,b,2,9)
end

function move_away()
   if distance() < 32 then
      if x > a then
	 a = a - 1
      else
	 a = a + 1
      end
      if y > b then
	 b = b - 1
      else
	 b = b + 1
      end
   end
end

function limit(a)
   if a > 127 then return 127 end
   if a < 0 then return 0 end
   return a
end

function distance()
   return sqrt((x-a)^2 + (y-b)^2)
end
