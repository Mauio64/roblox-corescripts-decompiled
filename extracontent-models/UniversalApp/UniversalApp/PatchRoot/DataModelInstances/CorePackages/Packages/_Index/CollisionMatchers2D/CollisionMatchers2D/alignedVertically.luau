local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function alignedVertically(p, p2, p3)
	local v = toRect(p)
	local v2 = toRect(p2)

	if p3 == Enum.VerticalAlignment.Top then
		return returnValue(v.Min.Y == v2.Min.Y, "", "")
	end

	if p3 == Enum.VerticalAlignment.Center then
		local midpoint = (v.Min + v.Max) / 2
		local midpoint2 = (v2.Min + v2.Max) / 2
		return returnValue(midpoint.Y == midpoint2.Y, "", "")
	elseif p3 == Enum.VerticalAlignment.Bottom then
		return returnValue(v.Max.Y == v2.Max.Y, "", "")
	else
		return returnValue(false, "Invalid VerticalAlignment!")
	end
end

return alignedVertically
