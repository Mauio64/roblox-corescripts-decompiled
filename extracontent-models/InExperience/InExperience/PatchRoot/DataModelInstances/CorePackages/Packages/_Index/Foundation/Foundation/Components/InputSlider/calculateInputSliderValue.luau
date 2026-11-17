local getStepGridPosition = require(script.Parent.getStepGridPosition)

local function calculateInputSliderValue(value: number, p: number, p2: number, p3: number?, range: NumberRange)
	local v = p * p2
	local v2 = math.sign(v) * math.floor((math.abs(v)))

	if v2 == 0 then
		return (math.clamp(value, range.Min, range.Max))
	end

	local v3 = value + v2

	if p3 ~= nil then
		local stepGridPosition = getStepGridPosition(value, p3, range)
		local v4

		if v2 > 0 then
			v4 = math.floor(stepGridPosition)
		else
			v4 = math.ceil(stepGridPosition)
		end

		v3 = range.Min + (v4 + v2) * p3
	end

	return (math.clamp(v3, range.Min, range.Max))
end

return calculateInputSliderValue
