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
                       function(_, u)
                          return u:IsValid()
                       end)
end

local function isLegion(_, unit)
   return unit:GetTeam() == HoN.GetLegionTeam()
end

local function isHellbourne(_, unit)
   return unit:GetTeam() == HoN.GetHellbourneTeam()
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

local function barracksOfLane(world, lane, team)

end

local function senseWorld(ally)
   local buildings = pingBuildings()
   local w = {
      ally = ally,
      legionTowers
         = util.pfilter(buildings, util.pand(isLegion, isTower, isValid)),
      hellbourneTowers
         = util.pfilter(buildings, util.pand(isHellbourne, isTower, isValid)),
      legionRaxes
         = util.pfilter(buildings, util.pand(isLegion, isRax, isValid)),
      hellbourneRaxes
         = util.pfilter(buildings, util.pand(isHellbourne, isRax, isValid))
   }

   return w
end

sense = {
   senseWorld = senseWorld
}