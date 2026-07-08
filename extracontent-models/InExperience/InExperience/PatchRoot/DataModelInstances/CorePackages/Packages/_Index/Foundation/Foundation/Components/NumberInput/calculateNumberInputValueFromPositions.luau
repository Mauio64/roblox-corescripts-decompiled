local function calculateNumberInputValueFromPositions(n1: number, n2: number, n3: number, n4: number) -- line: 5
	return n1 + (n3 - n2) * n4
end

return calculateNumberInputValueFromPositions
