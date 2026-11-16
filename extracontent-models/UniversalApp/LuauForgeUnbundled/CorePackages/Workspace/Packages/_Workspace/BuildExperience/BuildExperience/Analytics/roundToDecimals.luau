local function roundToDecimals(p2, p3)
	local v5 = 10 ^ p3
	return math.floor(p2 * v5 + 0.5) / v5
end

return roundToDecimals
