local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function intersect(p1, p2) -- line: 24
	-- upvalues: toRect (copy), returnValue (copy)
	local v6 = toRect(p1)
	local v7 = toRect(p2)

	return returnValue(math.abs(v6.Min.X - v7.Min.X) * 2 < v6.Width + v7.Width and math.abs(v6.Min.Y - v7.Min.Y) * 2 < v6.Height + v7.Height, "Intersects the element", "Does not intersect the element")
end

return intersect
