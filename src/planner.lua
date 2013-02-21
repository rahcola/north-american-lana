local world = dofile("game/bots/mybot/world.lua")
local act = dofile("game/bots/mybot/act.lua")
local util = dofile("game/bots/mybot/util.lua")

local function randomStep(state)
   local distance = math.random(150, 500)
   local angle = math.random(0,7) * math.pi / 4
   local displacement = distance * Vector3.Create(math.sin(angle),
                                                  math.cos(angle))
   local p = state.me.position + displacement
   if world.impassable(p) then
      p = state.me.position
   end
   return act.move(state.me.unit, p)
end

local function randomPlan(state, length)
   return util.repeatedly(length, randomStep, state)
end

local function evaluateState(state)
   local target = Vector3.Create(1500, 1500)
   local fromTarget = Vector3.Distance2D(state.me.position, target)
   local fitness = 1 / ((0.099 * fromTarget) + 1)
   --local fitness = (-fromTarget/20000) + 1

   return fitness
end

local function simulatePlan(state, plan, maxDepth)
   return util.foldl(function (state, step)
                        return step:simulate(state)
                     end,
                     state,
                     util.take(maxDepth, plan))
end

local function evaluatePlan(state, plan, simulations, maxDepth)
   local p = function()
      return evaluateState(simulatePlan(state, plan, maxDepth))
   end

   return util.min(util.repeatedly(simulations, p))
end

local function plan(state)
   local plans = 100
   local planLength = 5
   local simulations = 1
   local maxDepth = 10

   local p = function ()
      local plan = randomPlan(state, planLength)
      return {evaluatePlan(state, plan, simulations, maxDepth), plan}
   end
   local _, bestPlan = unpack(util.maximal(util.repeatedly(plans, p)))
   return bestPlan
end

return {
   plan = plan
       }