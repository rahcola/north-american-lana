local function tableToString(t)
   local s = ""

   for k, v in pairs(t) do
      local vs = tostring(v)
      if type(v) == "table" then
         vs = tableToString(v)
      end
      s = s..tostring(k).." = "..vs.."\n"
   end

   return s
end

local function pfilter(table, pred)
   local r = {}
   for k, v in pairs(table) do
      if k and v and pred(k, v) then
         r[k] = v
      end
   end
   return r
end

local function ifilter(table, pred)
   local r = {}
   
   for i, v in ipairs(table) do
      if pred(i, v) then
         r[i] = v
      end
   end

   return r
end

local function times(n, x)
   local t = {}
   
   for i = 1, n do
      t[i] = x
   end
   
   return t
end

local function repeatedly(n, f)
   local t = {}

   for i = 1, n do
      t[i] = f()
   end

   return t
end

local function zip(iter1, iter2)
   return function(state, index)
      local i1, v1 = iter1[1](state[1], index[1])
      local i2, v2 = iter2[1](state[2], index[2])
      return {i1, i2}, {v1, v2}
          end,
   {iter1[2], iter2[2]},
   {iter1[3], iter2[3]}
end

local function take(n, iter)
   local taken = 0
   
   return function(state, index)
      if taken >= n then
         return nil
      end
      taken = taken + 1
      return iter(state[2], index)
          end,
   {0, iter[2]}
   iter[3]
end

local function pand(...)
   return function (_, a)
      for _, p in ipairs(arg) do
         if not p(a) then
            return false
         end
      end
      return true
   end
end

util = {
   tableToString = tableToString,
   pfilter = pfilter,
   ifilter = ifilter,
   times = times,
   repeatedly = repeatedly,
   zip = zip,
   take = take,
   pand = pand
}