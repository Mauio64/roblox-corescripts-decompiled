local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function leftOf(p1, p2, p3) -- line: 38
	-- upvalues: toRect (copy), returnValue (copy)
	local v7 = toRect(p1)
	local v8 = toRect(p2)
	local v9 = -(v7.Max - v8.Min)

	if p3 then
		if typeof(p3) == "number" then
			p3 = NumberRange.new(p3)
		end

		return returnValue(p3.Min <= v9.X and p3.Max >= v9.X, "Was within range", "Was not within range ( " .. tostring(p3) .. ")")
	end

	return returnValue(v9.X >= 0, "Was not right of the element", "Was to the right of the element")
end

return leftOf
