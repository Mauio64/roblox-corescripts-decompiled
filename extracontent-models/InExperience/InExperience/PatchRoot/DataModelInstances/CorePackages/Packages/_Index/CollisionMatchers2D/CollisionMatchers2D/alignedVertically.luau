local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function alignedVertically(p1, p2, p3) -- line: 29
	-- upvalues: toRect (copy), returnValue (copy)
	local v7 = toRect(p1)
	local v8 = toRect(p2)

	if p3 == Enum.VerticalAlignment.Top then
		return returnValue(v7.Min.Y == v8.Min.Y, "", "")
	end

	if p3 == Enum.VerticalAlignment.Center then
		local v9 = (v7.Min + v7.Max) / 2
		local v10 = (v8.Min + v8.Max) / 2

		return returnValue(v9.Y == v10.Y, "", "")
	end

	if p3 == Enum.VerticalAlignment.Bottom then
		return returnValue(v7.Max.Y == v8.Max.Y, "", "")
	end

	return returnValue(false, "Invalid VerticalAlignment!")
end

return alignedVertically
