log = {}

function log:info(msg)
   Echo(msg)
end

local function randomHeroName()
   local heroNames = dofile("game/bots/mybot/hero_names.lua")
   local i = math.random(#heroNames)
   return heroNames[i]
end

function object:onpickframe()
   if not self:HasSelectedHero() then
      local hero = randomHeroName()
      log:info("Trying to pick "..hero)

      self:SelectHero(hero)
      if self:HasSelectedHero() then
         log:info("Picked "..hero)
         self:Ready()
      end
   end
end

function object:oncombatevent(event)
   
end

local UNIT = 0x0000001
local BUILDING = 0x0000002
local HERO = 0x0000004
local POWERUP = 0x0000008
local GADGET = 0x0000010
local ALIVE = 0x0000020
local CORPSE = 0x0000040

local function isAlly(botBrain, unit)
   return unit:GetTeam() == botBrain:GetHeroUnit():GetTeam()
end

local function isEnemy(botBrain, unit)
   return not isAlly(botBrain, unit)
end

local function allyTowersAlive(botBrain)
   local buildings = HoN.GetUnitsInRadius(Vector3.Create(),
                                          99999,
                                          ALIVE + BUILDING)
   local towers = {}
   for _, building in pairs(buildings) do
      if building:IsTower() and isAlly(botBrain, building) then
         table.insert(towers, building)
      end
   end
   
   return towers
end

local function playerPosition(botBrain)
   return botBrain:GetHeroUnit():GetPosition()
end

local function enemyHeros(botBrain)
   local units = HoN.GetUnitsInRadius(Vector3.Create(), 99999, HERO + ALIVE)
   local heros = {}
   for _, unit in pairs(units) do
      if isEnemy(botBrain, unit) then
         table.insert(heros, unit)
      end
   end

   return heros
end

local function sense(botBrain, gameVariables)
   for _, tower in pairs(allyTowersAlive(botBrain)) do
      HoN.DrawDebugLine(playerPosition(botBrain),
                        tower:GetPosition(),
                        true, "blue")
   end
   for _, enemy in pairs(enemyHeros(botBrain)) do
      HoN.DrawDebugLine(playerPosition(botBrain),
                        enemy:GetPosition(),
                        true, "red")
   end
end

function object:onthink(gameVariables)
   sense(self, gameVariables)
end