local function new(unit)
   return {
      unit = unit,
      position = unit:GetPosition()
          }
end

hero = {
   new = new
}