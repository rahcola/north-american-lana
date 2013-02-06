local function new(building)
   local t = {
      building = building
   }

   setmetatable(t, {__index = building})

   return t
end

local function positionSort(t1, t2)
   local u = t1.position
   local v = t2.position

   if u.x > v.x then
      return true
   end
   if u.y > v.y then
      return true
   end

   return false
end

local positions = {
   top_base = "top_base",
   bot_base = "bot_base",
   top_1 = "top_1",
   top_2 = "top_2",
   top_3 = "top_3",
   mid_1 = "mid_1",
   mid_2 = "mid_2",
   mid_3 = "mid_3",
   bot_1 = "bot_1",
   bot_2 = "bot_2",
   bot_3 = "bot_3"
}

local function annotateLegion(towers)
   table.sort(towers, positionSort)

   towers[1].position = positions.bot_3
   towers[2].position = positions.bot_2
   towers[3].position = positions.mid_3

   towers[4].position = positions.mid_2
   towers[5].position = positions.bot_1
   towers[6].position = positions.mid_1

   towers[7].position = positions.bot_base
   towers[8].position = positions.top_base
   towers[9].position = positions.top_3

   towers[10].position = positions.top_2
   towers[11].position = positions.top_1

   return towers
end

tower = {
   new = new
}