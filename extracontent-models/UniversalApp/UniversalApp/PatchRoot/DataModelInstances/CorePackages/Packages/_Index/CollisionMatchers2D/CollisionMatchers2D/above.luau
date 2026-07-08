local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function above(p1, p2, n1: number) -- line: 38
	-- upvalues: toRect (copy), returnValue (copy)
	local v7 = toRect(p1)
	local v8 = toRect(p2)
	local v9 = -(v7.Max - v8.Min)

	if n1 then
		if typeof(n1) == "number" then
			n1 = NumberRange.new(n1)
		end

		return returnValue(n1.Min <= v9.Y and n1.Max >= v9.Y, "Was within range", "Was not within range ( " .. tostring(n1) .. ")")
	end

	return returnValue(v9.Y >= 0, "Was above the element", "Was below the element")
end

return above
