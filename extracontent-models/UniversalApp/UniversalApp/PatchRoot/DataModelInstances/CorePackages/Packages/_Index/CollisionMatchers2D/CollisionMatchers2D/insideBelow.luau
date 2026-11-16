local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function insideBelow(p, p2, value)
	local v = toRect(p)
	local v2 = toRect(p2)

	local v3 = v.Min - v2.Min

	if not value then
		return returnValue(v3.Y >= 0, "Was not above the element", "Was too far above the element")
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

return insideBelow
