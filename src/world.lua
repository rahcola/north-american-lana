dofile "game/bots/mybot/util.lua"
dofile "game/bots/mybot/const.lua"
dofile "game/bots/mybot/hero.lua"

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

local function isImpassable(p)
   local b = HoN.GetUnitsInRadius(p, 30, ALIVE + BUILDING)
   local t = HoN.GetTreesInRadius(p, 30)
   return next(b) or next(t)
end

local function refreshWorld(world)
   --[[
   local isAlly = isAlly(world.me:GetTeam())
   local creeps = pingUnits()

   world = util.assoc(world,
                      "enemyHeroes",
                      idToUnitTable(util.pfilter(pingHeroes(), isEnemy)))
   world = util.assoc(world,
                      "enemyCreeps",
                      idToUnitTable(util.pfilter(creeps, isEnemy)))
   world = util.assoc(world,
                      "allyCreeps",
                      idToUnitTable(util.pfilter(creeps, isAlly)))
      --]]
                      world = util.assoc(world, "matchTime", HoN.GetMatchTime())
   return util.assoc(world, "me",
                     util.assoc(world.me, "position", world.me.unit:GetPosition()))
end

local function new(botBrain)
   local w = {
      me = hero.new(botBrain:GetHeroUnit()),
      matchTime = HoN.GetMatchTime(),
      enemyHeroes = {},
      enemyCreeps = {},
      allyCreeps = {}
          }
   setmetatable(w, {__newindex = function (_, _, _) error("don't mutate")end})
   return w
end

world = {
   new = new,
   refreshWorld = refreshWorld,
   isImpassable = isImpassable
}