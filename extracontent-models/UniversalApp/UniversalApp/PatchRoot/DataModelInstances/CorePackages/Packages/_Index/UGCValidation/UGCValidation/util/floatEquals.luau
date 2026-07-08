local function floatEquals(n1: number, n2: number, n3: number?) -- line: 3
	return (n3 or 1E-12) >= math.abs(n1 - n2)
end

return floatEquals
