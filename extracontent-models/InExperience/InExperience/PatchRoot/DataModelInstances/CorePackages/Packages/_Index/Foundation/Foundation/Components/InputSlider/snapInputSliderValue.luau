local getStepGridPosition = require(script.Parent.getStepGridPosition)

local function snapInputSliderValue(value: number, p: number?, range: NumberRange)
	local v = math.clamp(value, range.Min, range.Max)

	if p == nil then
		return v
	end

	local v2 = range.Min + math.round((getStepGridPosition(v, p, range))) * p

	if math.abs(range.Max - v) < math.abs(v2 - v) then
		return range.Max
	end

	return (math.clamp(v2, range.Min, range.Max))
end

return snapInputSliderValue
