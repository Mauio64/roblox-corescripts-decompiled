local function getVisibleTileRange(p: number, p2: number, p3: number, p4: number, value: number?, max: number)
	if max <= 0 or p2 <= 0 then
		return 1, 0
	end

	local v = p2 + p3

	local v2 = p4 + (value or 0)

	local v3 = math.floor(p / v)

	if not (p - v3 * v < p2) then
		v3 += 1
	end

	return math.clamp(v3 + 1, 1, max), (math.clamp(math.ceil(p / v + v2), 1, max))
end

return getVisibleTileRange
