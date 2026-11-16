local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function alignedHorizontally(p, p2, p3)
	local v = toRect(p)
	local v2 = toRect(p2)

	if p3 == Enum.HorizontalAlignment.Left then
		return returnValue(v.Min.X == v2.Min.X, "", "")
	end

	if p3 == Enum.HorizontalAlignment.Center then
		local midpoint = (v.Min + v.Max) / 2
		local midpoint2 = (v2.Min + v2.Max) / 2
		return returnValue(midpoint.X == midpoint2.X, "", "")
	elseif p3 == Enum.HorizontalAlignment.Right then
		return returnValue(v.Max.X == v2.Max.X, "", "")
	else
		return returnValue(false, "Invalid horizontal alignment!")
	end
end

return alignedHorizontally
