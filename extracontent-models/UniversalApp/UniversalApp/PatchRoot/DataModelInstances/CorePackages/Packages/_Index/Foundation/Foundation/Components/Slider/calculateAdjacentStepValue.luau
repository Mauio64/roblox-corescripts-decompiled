local SliderStepDirection = require(script.Parent.SliderStepDirection)

local SliderStepSize = require(script.Parent.SliderStepSize)

local function calculateAdjacentStepValue(p: number, p2, range: NumberRange, p3: number?, p4)
	local v = range.Max - range.Min
	local v2 = p2 == SliderStepDirection.Increment

	if p3 and p3 > 0 then
		local v3 = p4 ~= SliderStepSize.Page and 1 or math.max(1, (math.round(0.1 * v / p3)))

		local v4 = (p - range.Min) / p3
		local v5 = math.max(1, (math.abs(v4))) * 1e-6
		local v6

		if v2 then
			v6 = math.floor(v4 + v5) + v3
		else
			v6 = math.ceil(v4 - v5) - v3
		end

		return (math.clamp(range.Min + v6 * p3, range.Min, range.Max))
	else
		local v3

		if p4 == SliderStepSize.Page then
			v3 = 0.1 * v
		else
			v3 = 0.01 * v
		end

		if not v2 then
			v3 = -v3
		end

		return (math.clamp(p + v3, range.Min, range.Max))
	end
end

return calculateAdjacentStepValue
