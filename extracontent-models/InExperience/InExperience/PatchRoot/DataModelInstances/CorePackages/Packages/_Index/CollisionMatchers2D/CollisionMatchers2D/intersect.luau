local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function intersect(p, p2)
	local v = toRect(p)
	local v2 = toRect(p2)

	return returnValue(
		math.abs(v.Min.X - v2.Min.X) * 2 < v.Width + v2.Width and math.abs(v.Min.Y - v2.Min.Y) * 2 < v.Height + v2.Height,
		"Intersects the element",
		"Does not intersect the element"
	)
end

return intersect
