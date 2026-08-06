local function calculatePixelsPerStep(n1: number, n2: number, numberRange: NumberRange) -- line: 5
	return n1 / ((numberRange.Max - numberRange.Min) / n2)
end

return calculatePixelsPerStep
