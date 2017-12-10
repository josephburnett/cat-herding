pico-8 cartridge // http://www.pico-8.com
version 15
__lua__

herder = { x = 64, y = 64, type = "herder" }
cats = [
  { x = 10, y = 10, type = "cat" }
]

function _update()
   move_herder(herder)
   for c in cats
      move_cat(c,herder)
   end
end

function _draw()
   rectfill(0,0,127,127,5)
   circfill(herder.x,herder.y,2,8)
   for c in cats
      circfill(c.x,c.y,2,9)
   end
end

function move_herder(h)
   if (btn(0)) then h.x=h.x-1 end
   if (btn(1)) then h.x=h.x+1 end
   if (btn(2)) then h.y=h.y-1 end
   if (btn(3)) then h.y=h.y+1 end
end

function move_cat(c,h)
   if distance(c,h) < 32 then
      c.x = away_from(c.x,h.x)
      c.y = away_from(c.y,h.y)
   end
end

function away_from(x1,x2)
   if x1 < x2 then
      return limit(x1-1)
   else
      return limit(x1+1)
   end
end

function limit(a)
   if a > 127 then return 127 end
   if a < 0 then return 0 end
   return a
end

function distance(a,b)
   return sqrt((a.x-b.x)^2 + (a.y-b.y)^2)
end
