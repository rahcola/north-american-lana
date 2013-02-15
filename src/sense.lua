dofile "game/bots/mybot/util.lua"
dofile "game/bots/mybot/const.lua"
dofile "game/bots/mybot/tower.lua"
dofile "game/bots/mybot/barracks.lua"

local UNIT = 0x0000001
local BUILDING = 0x0000002
local HERO = 0x0000004
local POWERUP = 0x0000008
local GADGET = 0x0000010
local ALIVE = 0x0000020
local CORPSE = 0x0000040

local function pingBuildings()
   return HoN.GetUnitsInRadius(Vector3.Create(7500, 7500, 0),
                               99999,
                               ALIVE + BUILDING)
end

local function pingUnits()
   return HoN.GetUnitsInRadius(Vector3.Create(7500, 7500, 0),
                               99999,
                               ALIVE + UNIT)
end

local function pingHeroes()
   return HoN.GetUnitsInRadius(Vector3.Create(7500, 7500, 0),
                               99999,
                               ALIVE + HERO)
end

local function clearInvalids(units)
   return util.pfilter(units,
                      function(u)
                         return u:IsValid()
                      end)
end

local function isLegion(_, unit)
   return unit:GetTeam() == HoN.GetLegionTeam()
end

local function isHellbourne(_, unit)
   return unit:GetTeam() == HoN.GetHellbourneTeam()
end

local function isAlly(allyTeam)
   if allyTeam == HoN.GetLegionTeam() then
      return isLegion
   else
      return isHellbourne
   end
end

local function isEnemy(allyTeam)
   if allyTeam == HoN.GetLegionTeam() then
      return isHellbourne
   else
      return isLegion
   end
end

local function isTower(_, unit)
   return unit:IsTower()
end

local function isRax(_, unit)
   return unit:IsRax()
end

local function isValid(_, unit)
   return unit:IsValid()
end

local function idToUnitTable(units)
   local t = {}

   for _, u in pairs(units) do
      t[u:GetUniqueID()] = u
   end

   return t
end

local function refreshWorld(world)
   local isAlly = isAlly(world.me:GetTeam())
   local creeps = pingUnits()

   world.enemyHeroes = idToUnitTable(util.pfilter(pingHeroes(), isEnemy))
   world.enemyCreeps = idToUnitTable(util.pfilter(creeps, isEnemy))
   world.allyCreeps = idToUnitTable(util.pfilter(creeps, isAlly))

   return world
end

local function new(botBrain)
   return {
      me = botBrain:GetHeroUnit()
      enemyHeroes = {},
      enemyCreeps = {},
      allyCreeps = {}
          }
end

sense = {
   new = new
   refreshWorld = refreshWorld
}