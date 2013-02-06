local function new(unit)
   local b = {
      unit = unit,
      position = unit:GetPosition(),
      hp = unit:GetHealth()
   }

   return b
end

building = {
   new = new
}