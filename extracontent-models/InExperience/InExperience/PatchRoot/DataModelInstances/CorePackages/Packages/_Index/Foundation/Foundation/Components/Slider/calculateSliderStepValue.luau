local function calculateSliderStepValue(p: number, p2: number, range: NumberRange)
	if p2 > 0 then
		local v = math.floor((p - range.Min) / p2 + 0.5)
		return (math.clamp(range.Min + v * p2, range.Min, range.Max))
	end

	return p
end

return calculateSliderStepValue
