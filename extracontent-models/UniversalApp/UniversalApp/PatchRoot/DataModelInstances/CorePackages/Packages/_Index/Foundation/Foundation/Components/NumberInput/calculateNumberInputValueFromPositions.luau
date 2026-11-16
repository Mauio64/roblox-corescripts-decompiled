local function calculateNumberInputValueFromPositions(p: number, p2: number, p3: number, p4: number, value: number?)
	return p + math.floor((p3 - p2) * (value or 1)) * p4
end

return calculateNumberInputValueFromPositions
