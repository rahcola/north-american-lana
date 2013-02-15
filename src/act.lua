dofile "game/bots/mybot/log.lua"
dofile "game/bots/mybot/const.lua"

local function isMoving(unit)
   return unit:GetBehavior() and unit:GetBehavior():IsTraveling()
end

local function closerThan(p, q, e)
   return Vector3.Distance2D(p, q) < e
end

local function action(execute, isDone, simulateExecute)
   return {
      execute = execute,
      isDone = isDone,
      simulateExecute = simulateExecute
          }
end

local function move(unit, p)
   local execute = function (botBrain)
      log.info("moving to "..tostring(p))
      botBrain:OrderPosition(unit, const.MOVE, p)
   end

   local isDone = function (botBrain)
      local magicThreshold = 50
      local currentPosition = unit:GetPosition()
      if not isMoving(unit)
         or closerThan(currentPosition, p, magicThreshold) then
         log.info("reached "..tostring(currentPosition))
         return true
      end
      
      return false
   end

   return action(execute, isDone, simulateExecute)
end

act = {
   move = move
}