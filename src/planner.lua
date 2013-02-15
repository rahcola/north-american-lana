dofile "game/bots/mybot/util.lua"

local function randomStep()
   local p = Vector3.Create()
   return move(p)
end

local function randomPlan()
   return {
      isPlan = true,
      steps = {},
      iterate = function (self)
         return self.iterator, self, 1
      end,
      iterator = function (self, index)
         self.steps[index] = self.steps[index] or randomStep()
         return index + 1, self.steps[index]
      end
          }
end

local function simulateStep(state, step, enemyStep)
   local i = math.random()

   if i < 0.5 then
      state = step:simulateExecute(state)
      state = enemyStep:simulateExecute(state)
   else
      state = enemyStep:simulateExecute(state)
      state = step:simulateExecute(state)
   end

   return state
end

local function simulatePlan(state, myPlan, enemyPlan, maxDepth)
   for _, steps in util.take(maxDepth,
                             util.zip({plan.iterate()},
                                      {enemyPlan.iterate()})) do
      state = simulateStep(state, steps[1], steps[2])
   end

   return state
end

local function evaluatePlan(state, plan, simulations, maxDepth)
   local s = function()
      local freshState = copyState(state)
      local enemyPlan = randomPlan()
      return evaluateState(simulatePlan(freshState, plan, enemyPlan, maxDepth))
   end

   return math.min(unpack(util.repeatedly(simulations, s)))
end

local function plan(world)
   local plans = 2
   local simulations = 2
   local maxDepth = 10

   local maxScore = -math.huge
   local bestPlan = nil
   for i = 1, plans do
      local plan = randomPlan()
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