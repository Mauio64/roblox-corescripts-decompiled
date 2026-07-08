local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function insideRightOf(p1, p2, p3) -- line: 29
	-- upvalues: toRect (copy), returnValue (copy)
	local v7 = toRect(p1)
	local v8 = toRect(p2)
	local v9 = v7.Min - v8.Min

	if p3 then
		if typeof(p3) == "number" then
			p3 = NumberRange.new(p3)
		end

		return returnValue(p3.Min <= v9.X and p3.Max >= v9.X, "Was within range", "Was not within range ( " .. tostring(p3) .. ")")
	end

	return returnValue(v9.X >= 0, "Was not left of the element", "Was too far left of the element")
end

return insideRightOf
