dofile "game/bots/mybot/log.lua"
dofile "game/bots/mybot/draw.lua"
dofile "game/bots/mybot/sense.lua"
dofile "game/bots/mybot/think.lua"
dofile "game/bots/mybot/act.lua"

local function randomHeroName()
   local heroNames = dofile("game/bots/mybot/hero_names.lua")
   local i = math.random(#heroNames)
   return heroNames[i]
end

function object:onpickframe()
   if not self:HasSelectedHero() then
      local hero = randomHeroName()
      log.info("trying to pick "..hero)

      self:SelectHero(hero)
      if self:HasSelectedHero() then
         log.info("picked "..hero)
         self:Ready()
      end
   end
end

function object:oncombatevent(event)
end

local action = coroutine.wrap(function (_) return true end)

function object:onthink(gameVariables)
   --local world = sense.senseWorld(self:GetHeroUnit():GetTeam())
   --local action = think.think(world)
   local p = Vector3.Create(3500, 3500, 0)
   draw.arrowFromTo(self:GetHeroUnit():GetPosition(), p, "red")
   if action(self) then
      action = act.moveMe(p)
   end
end