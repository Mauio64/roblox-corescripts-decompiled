local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function alignedHorizontally(p1, p2, p3) -- line: 28
	-- upvalues: toRect (copy), returnValue (copy)
	local v7 = toRect(p1)
	local v8 = toRect(p2)

	if p3 == Enum.HorizontalAlignment.Left then
		return returnValue(v7.Min.X == v8.Min.X, "", "")
	end

	if p3 == Enum.HorizontalAlignment.Center then
		local v9 = (v7.Min + v7.Max) / 2
		local v10 = (v8.Min + v8.Max) / 2

		return returnValue(v9.X == v10.X, "", "")
	end

	if p3 == Enum.HorizontalAlignment.Right then
		return returnValue(v7.Max.X == v8.Max.X, "", "")
	end

	return returnValue(false, "Invalid horizontal alignment!")
end

return alignedHorizontally
