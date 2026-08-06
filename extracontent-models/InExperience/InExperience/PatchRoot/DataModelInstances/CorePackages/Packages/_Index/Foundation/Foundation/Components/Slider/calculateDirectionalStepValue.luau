local SliderStepDirection = require(script.Parent.SliderStepDirection)
local SliderStepSize = require(script.Parent.SliderStepSize)

local function calculateDirectionalStepValue(n1: number, p1, numberRange: NumberRange, n2: number?, p2) -- line: 11
	-- upvalues: SliderStepSize (copy), SliderStepDirection (copy)
	local v9 = numberRange.Max - numberRange.Min
	local v10 = if p2 ~= SliderStepSize.Page then if not n2 or not (n2 > 0) then 0.01 * v9 else n2 else math.max(0.1 * v9, n2 or 0)

	return (math.clamp(n1 + if p1 ~= SliderStepDirection.Increment then -v10 else v10, numberRange.Min, numberRange.Max))
end

return calculateDirectionalStepValue
