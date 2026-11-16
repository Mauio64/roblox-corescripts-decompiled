local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function insideRightOf(p, p2, value)
	local v = toRect(p)
	local v2 = toRect(p2)

	local v3 = v.Min - v2.Min

	if not value then
		return returnValue(v3.X >= 0, "Was not left of the element", "Was too far left of the element")
	end

	if typeof(value) == "number" then
		value = NumberRange.new(value)
	end

	return returnValue(
		value.Min <= v3.X and value.Max >= v3.X,
		"Was within range",
		"Was not within range ( " .. tostring(value) .. ")"
	)
end

return insideRightOf
