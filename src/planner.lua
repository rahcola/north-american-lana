dofile "game/bots/mybot/util.lua"
dofile "game/bots/mybot/world.lua"

local function randomStep(state)
   local distance = math.random(101, 500)
   local angle = math.random(0,2*math.pi)
   local p = distance * Vector3.Create(math.sin(angle), math.cos(angle))
   if world.isImpassable(p) then
      p = Vector3.Create(0, 0)
   end
   return act.moveAlong(state.me.unit, p)
end

local function randomPlan(state)
   return {
      isPlan = true,
      steps = {},
      iterate = function (self)
         return self.iterator, self, 1
      end,
      iterator = function (self, index)
         if index > 5 then
            return nil
         end

         self.steps[index] = self.steps[index] or randomStep(state)
         return index + 1, self.steps[index]
      end
          }
end

local function simulateStep(state, step, enemyStep)
   local i = math.random()

   if i < 0.5 then
      state = step.simulateExecute(state)
      state = enemyStep.simulateExecute(state)
   else
      state = enemyStep.simulateExecute(state)
      state = step.simulateExecute(state)
   end

   return state
end

local function simulatePlan(state, myPlan, enemyPlan, maxDepth)
   for _, steps in util.take(maxDepth,
                             util.zip({myPlan:iterate()},
                                      {enemyPlan:iterate()})) do
      state = simulateStep(state, steps[1], steps[2])
   end

   return state
end

local function evaluateState(state)
   local target = Vector3.Create(1500, 1500)
   local fromTarget = Vector3.Distance2D(state.me.position, target)
   --local fitness = 1 / ((0.099 * fromTarget) + 1)
   local fitness = (-fromTarget/20000) + 1
   Echo("from target "..tostring(fromTarget))
   Echo("fitness "..tostring(fitness))
   return fitness
end

local function evaluatePlan(state, plan, simulations, maxDepth)
   local s = function()
      local enemyPlan = randomPlan(state)
      return evaluateState(simulatePlan(state, plan, enemyPlan, maxDepth))
   end

   return math.min(unpack(util.repeatedly(simulations, s)))
end

local function plan(world)
   local plans = 200
   local simulations = 1
   local maxDepth = 10

   local maxScore = -math.huge
   local bestPlan = nil
   for i = 1, plans do
      local plan = randomPlan(world)
      local score = evaluatePlan(world,
                                 plan,
                                 simulations,
                                 maxDepth)
      if score > maxScore then
         maxScore = score
         bestPlan = plan
      end
   end
   
   return bestPlan
end

planner = {
   plan = plan
}