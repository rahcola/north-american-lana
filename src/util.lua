local function tableToString(t, i)
   i = i or 0
   local indent = string.rep(".", i)
   local s = indent.."{\n"

   for k, v in pairs(t) do
      local vs = tostring(v)
      if type(v) == "table" then
         vs = "\n"..tableToString(v, i+1)
      end
      s = s..indent..tostring(k).." = "..vs.."\n"
   end

   return s..indent.."}"
end

local function assoc(table, key, value)
   local new = {}
   for k, v in pairs(table) do
      new[k] = v
   end
   new[key] = value
   return new
end

local function updateIn(table, keys, fn)
   local function r(table, i, k)
      if i == nil then
         return table
      end

      ii, kk = next(keys, i)
      if ii == nil then
         return assoc(table, k, fn(table[k]))
      else
         return assoc(table, k, r(table[k], ii, kk))
      end
   end

   return r(table, next(keys))
end

local function filter(table, pred)
   local r = {}
   for k, v in pairs(table) do
      if k and v and pred(k, v) then
         r[k] = v
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

local function repeatedly(n, f, ...)
   local t = {}

   for i = 1, n do
      t[i] = f(...)
   end

   return t
end

local function zip(table1, table2)
   local t = {}
   local i, x = next(table1)
   local j, y = next(table2)

   while i ~= nil and j ~= nil do
      table.insert(t, {x, y})
      i, x = next(table1, i)
      j, y = next(table2, j)
   end

   return t
end

local function foldl(fn, initial, table)
   local acc = initial
   for _, x in pairs(table) do
      acc = fn(acc, x)
   end
   return acc
end

local function min(table)
   return foldl(math.min, math.huge, table)
end

local function max(table)
   return foldl(math.max, math.huge, table)
end

local function maximal(table)
   return foldl(function (state, x)
                   local max, maximal = unpack(state)
                   local val, x = unpack(x)
                   if val > max then
                      max = val
                      maximal = x
                   end
                   return {max, maximal}
                end,
                {-math.huge, nil},
                table)
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

return {
   tableToString = tableToString,
   assoc = assoc,
   filter = filter,
   times = times,
   repeatedly = repeatedly,
   zip = zip,
   foldl = foldl,
   min = min,
   max = max,
   maximal = maximal,
   pand = pand,
   sharpAngle = sharpAngle
       }