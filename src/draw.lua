local function mark(p, color)
   local l = 50
   HoN.DrawDebugLine(Vector3.Create(p.x - l, p.y - l, p.z),
                     Vector3.Create(p.x + l, p.y + l, p.z),
                     false, color)
   HoN.DrawDebugLine(Vector3.Create(p.x + l, p.y - l, p.z),
                     Vector3.Create(p.x - l, p.y + l, p.z),
                     false, color)
end

local function arrowFromTo(p, q, color)
   HoN.DrawDebugLine(p, q, true, color)
end

draw = {
   mark = mark,
   arrowFromTo = arrowFromTo
}