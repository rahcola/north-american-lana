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
   pand = pand
}