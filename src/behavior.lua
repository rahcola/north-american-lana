local function new(action, utilityFunction)
   return {action = action, utilityFunction = utilityFunction}
end

local function execute(behavior)
   behavior.action()
end

local function utility(behavior)
   behavior.utilityFunction()
end

local function maxUtility(behaviors)
   local choice = nil
   local maxUtility = -1
   for _, b in pairs(behaviors) do
      local u = utility(b)
      if u > maxUtility then
         choice = b
         maxUtility = u
      end
   end
   return maxUtility, choice
end

local function selector(behaviors)
   local s = {executing = false}
   s.action = function ()
      if not executing then
         _, s.executing = maxUtility(behaviors)
      end
      s.executing = s.executing()
   end
   return
end

behavior = {
   new = new,
   execute = execute,
   utility = utility
}