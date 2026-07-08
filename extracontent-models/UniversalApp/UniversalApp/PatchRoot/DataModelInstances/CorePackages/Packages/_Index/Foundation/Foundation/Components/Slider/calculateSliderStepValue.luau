local function calculateSliderStepValue(n1: number, n2: number, numberRange: NumberRange) -- line: 1
	if n2 > 0 then
		local v5 = math.floor((n1 - numberRange.Min) / n2 + 0.5)

		return (math.clamp(numberRange.Min + v5 * n2, numberRange.Min, numberRange.Max))
	end

	return n1
end

return calculateSliderStepValue
