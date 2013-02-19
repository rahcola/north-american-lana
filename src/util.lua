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

local function assoc(table, key, value)
   local new = {}
   for k, v in pairs(table) do
      new[k] = v
   end
   new[key] = value
   setmetatable(new, {__newindex = function (_, _, _) error("don't mutate")end})
   return new
end

local function pfilter(table, pred)
   local r = {}
   for k, v in pairs(table) do
      if k and v and pred(k, v) then
         r[k] = v
      end
   end
   setmetatable(r, {__newindex = function (_, _, _) error("don't mutate")end})
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
      if (i1 == nil) or (i2 == nil) then
         return nil
      end
      return {i1, i2}, {v1, v2}
          end,
   {iter1[2], iter2[2]},
   {iter1[3], iter2[3]}
end

local function take(n, f, s, i)
   local taken = 0
   
   return
   function(state, index)
      if taken >= n then
         return nil
      end
      taken = taken + 1
      return f(s, index)
   end,
   {0, s},
   i
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

local function sharpAngle(p, q)
   return math.acos(Vector3.Dot(Vector3.Normalize(p),
                                Vector3.Normalize(q)))
end

util = {
   tableToString = tableToString,
   assoc = assoc,
   pfilter = pfilter,
   ifilter = ifilter,
   times = times,
   repeatedly = repeatedly,
   zip = zip,
   take = take,
   pand = pand,
   sharpAngle = sharpAngle
}