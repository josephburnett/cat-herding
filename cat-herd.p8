pico-8 cartridge // http://www.pico-8.com
version 15
__lua__

herder = { x=64, y=64, v=0 }
cats = {
   { x=10, y=10, vs=0, vx=0, vy=0, i=flr(rnd(32)) }
}

function _update()
   move_herder(herder)
   for c in all(cats) do
      move_cat(c,herder)
   end
end

function _draw()
   rectfill(0,0,127,127,5)
   circfill(herder.x,herder.y,2,8)
   for c in all(cats) do
      circfill(c.x,c.y,2,9)
   end
end

function move_herder(h)
   if (btn(0)) then h.x=limit(h.x-1) end
   if (btn(1)) then h.x=limit(h.x+1) end
   if (btn(2)) then h.y=limit(h.y-1) end
   if (btn(3)) then h.y=limit(h.y+1) end
end

function move_cat(c,h)
   local d = distance(c,h)
   if d < 50 then
      --accelerate
      c.vs = flr((50-d)/8)
   else
      --decelerate
      c.vs = ceil(c.vs/1.1)
   end
   c.vs = max(1,c.vs)
   if c.vs == 1 then
      --walk
      c.i = (c.i + 1) % 64
      if c.i < 32 then
	 --rest
	 c.vx = 0
	 c.vy = 0
      elseif c.i == 32 then
	 --wander
	 c.vx = flr(rnd(3))-1
	 c.vy = flr(rnd(3))-1
      end
      c.x = limit(c.x + c.vx)
      c.y = limit(c.y + c.vy)
   elseif c.vs > 0 then
      --run
      for _=1,c.vs do
         c.x, c.vx = away_from(c.x,h.x)
         c.y, c.vy = away_from(c.y,h.y)
      end
   end
end

function away_from(x1,x2)
   if x1 < x2 then
      return limit(x1-1),-1
   elseif x1 > x2 then
      return limit(x1+1),1
   elseif flr(rnd(2)) == 0 then
      return limit(x1+1),1
   else
      return limit(x1-1),-1
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
