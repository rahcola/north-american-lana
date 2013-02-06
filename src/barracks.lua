local function new(building)
   local t = {
      building = building
   }

   setmetatable(t, {__index = building})

   return t
end

barracks = {
   new = new
}