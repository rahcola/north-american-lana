dofile "game/bots/mybot/const.lua"
dofile "game/bots/mybot/sense.lua"
dofile "game/bots/mybot/act.lua"

local function closerThan(p, q, e)
   return Vector3.Distance2D(p, q) < e
end

local function plan(action, world)
   local p1 = Vector3.Create(4000, 4000, 0)
   local p2 = Vector3.Create(3000, 3000, 0)
end

think = {
   think = think
}