dofile "game/bots/mybot/const.lua"
dofile "game/bots/mybot/sense.lua"
dofile "game/bots/mybot/act.lua"

local function selectLane(world)
   local i = math.random(3)
   local lanes = {TOP_LANE, MID_LANE, BOT_LANE}
   return lanes[i]
end

local function think(world)
   local lane = selectLane(world)

   local barracks = sense.barracksOfLane(world, lane, world.ally)
   return act.moveMe(barracks.position)
end

think = {
   think = think
}