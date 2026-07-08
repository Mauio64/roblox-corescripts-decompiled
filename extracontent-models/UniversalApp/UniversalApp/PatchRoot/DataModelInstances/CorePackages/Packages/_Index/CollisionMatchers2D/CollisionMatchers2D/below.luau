local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

local function below(p1, p2, p3) -- line: 33
	-- upvalues: toRect (copy), returnValue (copy)
	local v7 = toRect(p1)
	local v8 = toRect(p2)
	local v9 = v7.Min - v8.Max

	if p3 then
		if typeof(p3) == "number" then
			p3 = NumberRange.new(p3)
		end

		return returnValue(p3.Min <= v9.Y and p3.Max >= v9.Y, "Was within range", "Was not within range ( " .. tostring(p3) .. ")")
	end

	return returnValue(v9.Y >= 0, "Was below the element", "Was above the element")
end

return below
