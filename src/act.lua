dofile "game/bots/mybot/log.lua"
dofile "game/bots/mybot/const.lua"

local wrap = coroutine.wrap

local function moveUntilThere(botBrain, unit, p)
   if Vector3.Distance2D(unit:GetPosition(), p) < 10 then
      log.info("already there")
      return true
   end

   log.info("moving to "..tostring(p))
   botBrain:OrderPosition(unit, const.MOVE, p)

   local moving = true
   while moving do
      coroutine.yield(false)
      -- FIXME
   end

   return true
end

local function move(unit, p)
   return wrap(
      function (botBrain)
         return moveUntilThere(botBrain, unit, p)
      end)
end

local function moveMe(p)
   return wrap(
      function (botBrain)
         return moveUntilThere(botBrain, botBrain:GetHeroUnit(), p)
      end)
end

act = {
   move = move,
   moveMe = moveMe
}