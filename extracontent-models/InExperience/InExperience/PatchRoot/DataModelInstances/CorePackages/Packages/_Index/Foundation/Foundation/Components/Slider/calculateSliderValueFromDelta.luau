local function calculateSliderValueFromDelta(n1: number, n2: number, numberRange: NumberRange) -- line: 6
	return (math.clamp(n1 + n2 * (numberRange.Max - numberRange.Min), numberRange.Min, numberRange.Max))
end

return calculateSliderValueFromDelta
