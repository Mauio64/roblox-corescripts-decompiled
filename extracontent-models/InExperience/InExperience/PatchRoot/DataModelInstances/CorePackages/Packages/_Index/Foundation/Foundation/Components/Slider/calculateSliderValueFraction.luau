local function calculateSliderValueFraction(p: number, range: NumberRange)
	return (math.clamp((p - range.Min) / (range.Max - range.Min), 0, 1))
end

return calculateSliderValueFraction
