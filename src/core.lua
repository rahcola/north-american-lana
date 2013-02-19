dofile "game/bots/mybot/log.lua"
dofile "game/bots/mybot/draw.lua"
dofile "game/bots/mybot/world.lua"
dofile "game/bots/mybot/planner.lua"
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

local w = world.new(object)
local plan = nil
local itr = nil
local s = nil
local i = nil
local action = nil

function object:onthink(gameVariables)
   w = world.refreshWorld(w)
   if plan == nil then
      plan = planner.plan(w)
      itr, s, i = plan:iterate()
   end

   if action == nil then
      i, action = itr(s, i)
      if action == nil then
         log.info("plan done")
         plan = nil
      else
         log.info("new step")
         action.execute(self)
      end
   end

   if action and action.isDone(self) then
      action = nil
   end
end