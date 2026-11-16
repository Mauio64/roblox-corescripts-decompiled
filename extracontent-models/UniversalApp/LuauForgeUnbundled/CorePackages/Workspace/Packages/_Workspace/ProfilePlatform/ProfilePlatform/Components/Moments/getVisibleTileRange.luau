local function getVisibleTileRange(p2, p3, p4, p5, value, max)
	if max <= 0 or p3 <= 0 then
		return 1, 0
	end

	local v5 = p3 + p4

	local v6 = p5 + (value or 0)

	local v7 = math.floor(p2 / v5)

	if not (p2 - v7 * v5 < p3) then
		v7 += 1
	end

	return math.clamp(v7 + 1, 1, max), (math.clamp(math.ceil(p2 / v5 + v6), 1, max))
end

return getVisibleTileRange
