local function mkIteratee(state, h)
   return {state, h}
end

local function yield(x)
   return mkIteratee("yield", x)
end

local function continue(f)
   local o = mkIteratee("continue", f)
   setmetatable(o, {__call = function (_, x) return f(x) end})
   return o
end

local function isYield(i)
   return i[1] == "yield"
end

local function isContinue(i)
   return i[1] == "continue"
end

local function foldl(fn, initial)
   local function g(acc)
      return
      function (x)
         if x == nil then
            return yield(acc)
         end
         return continue(g(fn(acc, x)))
      end
   end
   return continue(g(initial))
end

local min = foldl(math.min, math.huge)

local max = foldl(math.max, -math.huge)

local maximal = foldl(function (state, x)
                         local max, maximal = unpack(state)
                         local val, x = unpack(x)
                         if val > max then
                            max = val
                            maximal = x
                         end
                         return {max, maximal}
                      end,
                      {-math.huge, nil})

local function valsEnumerator(table)
   return
   function (iteratee)
      if isContinue(iteratee) then
         for _, x in pairs(table) do
            iteratee = iteratee(x)
            if isYield(iteratee) then
               break
            end
         end
      end
      return iteratee
   end
end

local function EOFEnumerator(iteratee)
   if isYield(iteratee) then
      return iteratee
   end
   return iteratee(nil)
end

local function run(iteratee)
   return EOFEnumerator(iteratee)[2]
end

return {
   yield = yield,
   continue = continue,
   isYield = isYield,
   isContinue = isContinue,
   foldl = foldl,
   min = min,
   max = max,
   maximal = maximal,
   valsEnumerator = valsEnumerator,
   EOFEnumerator = EOFEnumerator,
   run = run
       }