local function roundToDecimals(p: number, p2: number)
	local v = 10 ^ p2
	return math.floor(p * v + 0.5) / v
end

return roundToDecimals
