local function randomHeroName()
   local heroNames = dofile("game/bots/mybot/hero_names.lua")
   local i = math.random(#heroNames)
   return heroNames[i]
end

function object:onpickframe()
   if not self:HasSelectedHero() then
      local hero = randomHeroName()
      Echo("Trying to pick "..hero)
      self:SelectHero(hero)
      if self:HasSelectedHero() then
         Echo("Picked "..hero)
         self:Ready()
      end
   end
end

function object:oncombatevent(event)
   
end

function object:onthink(gameVariables)

end