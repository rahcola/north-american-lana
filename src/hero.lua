local function new(unit)
   local o = {
      unit = unit,
      position = unit:GetPosition()
   }
   setmetatable(o, {__index = unit})
   
   return o
end

return {
   new = new
       }