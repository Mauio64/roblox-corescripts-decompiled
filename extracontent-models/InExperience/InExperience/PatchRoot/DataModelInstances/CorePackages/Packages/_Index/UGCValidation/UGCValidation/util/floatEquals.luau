local function floatEquals(p: number, p2: number, value: number?): boolean
	return (value or 1e-12) >= math.abs(p - p2)
end

return floatEquals
