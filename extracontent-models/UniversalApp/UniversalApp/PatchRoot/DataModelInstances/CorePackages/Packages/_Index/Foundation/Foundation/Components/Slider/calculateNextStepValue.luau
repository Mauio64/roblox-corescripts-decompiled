local function calculateNextStepValue(n1: number, n2: number, n3: number, numberRange: NumberRange) -- line: 1
	return (math.clamp(n2 + ((if not (n1 > 0) then not (n1 < 0) and 0 or -1 else 1)) * n3, numberRange.Min, numberRange.Max))
end

return calculateNextStepValue
