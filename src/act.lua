dofile "game/bots/mybot/log.lua"
dofile "game/bots/mybot/const.lua"
dofile "game/bots/mybot/draw.lua"

local function isStuck(unit)
   return unit:GetBehavior() and (not unit:GetBehavior():IsTraveling())
end

local function isIdle(unit)
   local b = unit:GetBehavior()
   if b == nil then
      return true
   end
   if b:isIdle() then
      return true
   end
   return false
end

local function closerThan(p, q, e)
   return Vector3.Distance2DSq(p, q) < e*e
end

local function action(execute, isDone, simulateExecute)
   return {
      execute = execute,
      isDone = isDone,
      simulateExecute = simulateExecute
          }
end

local nop = action(function () end,
                   function () return false end,
                   function (world) return world end)

local function move(unit, p)
   local execute = function (botBrain)
      log.info("moving to "..tostring(p))
      botBrain:OrderPosition(unit, const.MOVE, p)
   end

   local isDone = function (botBrain)
      local magicThreshold = 100
      local currentPosition = unit:GetPosition()

      draw.arrowFromTo(currentPosition, p, "red")
      if closerThan(currentPosition, p, magicThreshold) then
         log.info("reached "..tostring(currentPosition))
         return true
      end
      
      return false
   end

   local simulateExecute = function (world)
      local position = world.me.position
      local speed = unit:GetMoveSpeed()
      local distanceToTravel = Vector3.Distance2D(position, p)
      local timeToTravel = distanceToTravel / speed

      world = util.assoc(world, "me", util.assoc(world.me, "position", p))
      return util.assoc(world, "matchTime", world.matchTime + timeToTravel)
   end

   return action(execute, isDone, simulateExecute)
end

local function moveAlong(unit, p)
   return move(unit, unit:GetPosition() + p)
end

act = {
   nop = nop,
   move = move,
   moveAlong = moveAlong
}