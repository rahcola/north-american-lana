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

local world = sense.new(object)

function object:onthink(gameVariables)
   world = sense.refreshWorld(world)
   plan = planner.plan(world)
end