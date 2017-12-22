pico-8 cartridge // http://www.pico-8.com
version 15
__lua__

current_level = 1
levels = {
   {
      walls = {
	 { x=0, y=0, w=127, h=5},
	 { x=0, y=122, w=127, h=5},
	 { x=0, y=0, w=5, h=127},
	 { x=122, y=0, w=5, h=127},
	 { x=62, y=0, w=5, h=54},
	 { x=62, y=73, w=5, h=55},
      },
      herder = { x=64, y=64, v=0 },
      cats = {
	{ x=10, y=10, vs=0, vx=0, vy=0, i=flr(rnd(32)), c=9 },
	{ x=90, y=90, vs=0, vx=0, vy=0, i=flr(rnd(32)), c=9 },
      },
      beds = {
	 { x=68, y=110, w=20, h=11, c=9 },
      }
   },
   {
      walls = {
	 { x=0, y=0, w=127, h=5},
	 { x=0, y=122, w=127, h=5},
	 { x=0, y=0, w=5, h=127},
	 { x=122, y=0, w=5, h=127},
	 { x=62, y=0, w=5, h=54},
	 { x=62, y=73, w=5, h=55},
      },
      herder = { x=64, y=64, v=0 },
      cats = {
	{ x=10, y=10, vs=0, vx=0, vy=0, i=flr(rnd(32)), c=9 },
	{ x=90, y=90, vs=0, vx=0, vy=0, i=flr(rnd(32)), c=9 },
      },
      beds = {
	 { x=80, y=110, w=20, h=11, c=9 },
      }
   }
}
l = levels[current_level]
game_on = true

function _update()
   if game_on and is_win() then
      game_on = false
      level_up()
   end
   if game_on then
      move_herder(l.herder)
      for c in all(l.cats) do
	 move_cat(c,l.herder)
      end
   end
end

function _draw()
   rectfill(0,0,127,127,5)
   for b in all(l.beds) do
      rect(b.x,b.y,b.x+b.w,b.y+b.h,b.c)
   end
   for w in all(l.walls) do
      rectfill(w.x,w.y,w.x+w.w,w.y+w.h,1)
   end
   circfill(l.herder.x,l.herder.y,2,8)
   for c in all(l.cats) do
      circfill(c.x,c.y,2,9)
   end
end

function is_win()
   for c in all(l.cats) do
      local in_bed = false
      for b in all(l.beds) do
	 if c.x >= b.x and
	    c.x <= b.x+b.w and
	    c.y >= b.y and
	    c.y <= b.y+b.h
	 then
	    in_bed = true
	 end
      end
      if not in_bed then return false end
   end
   return true
end

function level_up()
   current_level = current_level + 1
   if levels[current_level] == nil then
      --game over
      return
   end
   l = levels[current_level]
   game_on = true
end

function move_herder(h)
   if (btn(0)) then h.x,h.y=move(h.x,h.y,-1,0) end
   if (btn(1)) then h.x,h.y=move(h.x,h.y,1,0) end
   if (btn(2)) then h.x,h.y=move(h.x,h.y,0,-1) end
   if (btn(3)) then h.x,h.y=move(h.x,h.y,0,1) end
end

function move_cat(c,h)
   local d = distance(c,h)
   if d < 50 then
      --accelerate
      c.vs = flr((50-d)/8)
   else
      --decelerate
      c.vs = flr(c.vs/1.1)
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
      c.x,c.y = move(c.x,c.y,c.vx,c.vy)
   else
      --run
      for _=1,c.vs do
         c.vx = away_from(c.x,h.x)
	 c.vy = away_from(c.y,h.y)
	 c.x,c.y = move(c.x,c.y,c.vx,0)
	 c.x,c.y = move(c.x,c.y,0,c.vy)
      end
   end
end

function away_from(x1,x2)
   local vx, vy = 0, 0
   if x1 < x2 then
      vx = -1
   elseif x1 > x2 then
      vx = 1
   elseif flr(rnd(2)) == 0 then
      vx = -1
   else
      vx = 1
   end
   return vx,vy
end

function move(x1,y1,dx,dy)
   local x2 = x1 + dx
   local y2 = y1 + dy
   --stay within the map
   if x2 > 127 then x2 = 127 end
   if x2 < 0 then x2 = 0 end
   if y2 > 127 then y2 = 127 end
   if y2 < 0 then y2 = 0 end
   --avoid walls
   for w in all(l.walls) do
      if x2 > w.x-2 and
	 x2 < w.x+2 + w.w and
	 y2 > w.y-2 and
	 y2 < w.y+2 + w.h
      then
	 return x1,y1
      end
   end
   return x2,y2
end

function distance(a,b)
   return sqrt((a.x-b.x)^2 + (a.y-b.y)^2)
end
