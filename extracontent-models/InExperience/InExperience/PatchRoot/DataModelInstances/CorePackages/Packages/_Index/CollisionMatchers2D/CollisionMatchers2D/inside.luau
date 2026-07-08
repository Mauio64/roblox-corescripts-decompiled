local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function isPointInside(p1, p2) -- line: 4
	return p1.X >= p2.Min.X and (p1.X <= p2.Max.X and (p1.Y >= p2.Min.Y and p1.Y <= p2.Max.Y))
end
local function inside(p3, p4) -- line: 26
	-- upvalues: toRect (copy), returnValue (copy)
	local v9 = toRect(p3)
	local v10 = toRect(p4)
	local v11 = returnValue
	local Min = v9.Min
	local v13 = Min.X >= v10.Min.X and (Min.X <= v10.Max.X and (Min.Y >= v10.Min.Y and Min.Y <= v10.Max.Y))

	if v13 then
		local Max = v9.Max

		v13 = Max.X >= v10.Min.X and (Max.X <= v10.Max.X and (Max.Y >= v10.Min.Y and Max.Y <= v10.Max.Y))
	end

	return v11(v13, "Is inside the element", "Is not inside the element")
end

return inside
