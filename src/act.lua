local log = dofile("game/bots/mybot/log.lua")
local const = dofile("game/bots/mybot/const.lua")
local draw = dofile("game/bots/mybot/draw.lua")

local function new(enumerator, simulate)
   return {enumerator = enumerator,
           simulate = simulate}
end

local function nop = new(function (iteratee) return iteratee end,
                         function (world) return world end)

local function isMoving(unit)
   local b = unit:GetBehavior()
   return b and b:GetMoving()
end

local function closerThan(p, q, e)
   return Vector3.Distance2DSq(p, q) < e*e
end

local function holdOrder(unit)
   return
   function (botBrain)
      botBrain:Order(unit, const.HOLD)
   end
end

local function moveOrder(unit, p)
   return
   function (botBrain)
      botBrain:OrderPosition(unit, const.MOVE, p)
   end
end

local function move(unit, p)
   return new(
      function (iteratee)
         if enum.isContinue(iteratee) then
            local magicThreshold = 100
            local currentPosition = unit:GetPosition()
            
            if closerThan(currentPosition, p, magicThreshold) then
               log.info("reached "..tostring(currentPosition))
               return iteratee(holdOrder(unit))
            end
            
            if not isMoving(unit) then
               log.info("moving to "..tostring(p))
               return iteratee(moveOrder(unit, p))
            end
         end
         return iteratee
      end,
      function (world)
         local position = world.me.position
         local speed = unit:GetMoveSpeed()
         local distanceToTravel = Vector3.Distance2D(position, p)
         local timeToTravel = distanceToTravel / speed
         
         world = util.updateIn(world, {"me", "position"}, function () return p end)
         world = util.assoc(world, "matchTime", world.matchTime + timeToTravel)
         return world
      end)
end

return {
   move = move,
   moveAlong = moveAlong
       }