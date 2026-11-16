local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function above(p, p2, value: number)
	local v = toRect(p)
	local v2 = toRect(p2)

	local v3 = -(v.Max - v2.Min)

	if not value then
		return returnValue(v3.Y >= 0, "Was above the element", "Was below the element")
	end

	if typeof(value) == "number" then
		value = NumberRange.new(value)
	end

	return returnValue(
		value.Min <= v3.Y and value.Max >= v3.Y,
		"Was within range",
		"Was not within range ( " .. tostring(value) .. ")"
	)
end

return above
