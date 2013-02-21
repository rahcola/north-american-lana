local log = dofile("game/bots/mybot/log.lua")
local draw = dofile("game/bots/mybot/draw.lua")
local world = dofile("game/bots/mybot/world.lua")
local planner = dofile("game/bots/mybot/planner.lua")
local act = dofile("game/bots/mybot/act.lua")

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
local i = nil
local action = nil

function object:onthink(gameVariables)
   w = world.refreshWorld(w)
   if plan == nil then
      plan = planner.plan(w)
   end

   if action == nil then
      i, action = next(plan, i)
      if i == nil then
         log.info("plan done")
         plan = nil
         return
      end
      log.info("new step")
   end

   if action.enumerator then
      action = nil
      return
   end
end