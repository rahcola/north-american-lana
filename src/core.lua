function object:onpickframe()
   if not self:HasSelectedHero() then
      Echo("Picking Flint")
      self:SelectHero("Hero_FlintBeastwood")
      self:Ready()
   end
end

function object:oncombatevent(event)
   
end

function object:onthink(gameVariables)

end