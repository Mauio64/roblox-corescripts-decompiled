local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function isPointInside(p, p2): boolean -- 2 equivalent calls inferred from this helper
	return p.X >= p2.Min.X and p.X <= p2.Max.X and p.Y >= p2.Min.Y and p.Y <= p2.Max.Y
end

local function inside(p, p2)
	local v = toRect(p)
	local v2 = toRect(p2)

	return returnValue(
		isPointInside(v.Min, v2) and isPointInside(v.Max, v2), -- inferred equivalent call
		"Is inside the element",
		"Is not inside the element"
	)
end

return inside
