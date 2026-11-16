local SliderStepDirection = require(script.Parent.SliderStepDirection)

local SliderStepSize = require(script.Parent.SliderStepSize)

local function calculateDirectionalStepValue(p: number, p2, range: NumberRange, value: number?, p3)
	local v = range.Max - range.Min

	if p3 == SliderStepSize.Page then
		value = math.max(0.1 * v, value or 0)
	elseif not (value and value > 0) then
		value = 0.01 * v
	end

	if p2 ~= SliderStepDirection.Increment then
		value = -value
	end

	return (math.clamp(p + value, range.Min, range.Max))
end

return calculateDirectionalStepValue
