local function getVisibleTileRange(n1: number, n2: number, n3: number, n4: number, n5: number?, n6: number) -- line: 12
	if n6 <= 0 or n2 <= 0 then
		return 1, 0
	end

	local v8 = n2 + n3
	local v9 = n4 + (n5 or 0)
	local v10 = math.floor(n1 / v8)

	return math.clamp(((if not (n2 > n1 - v10 * v8) then v10 + 1 else v10)) + 1, 1, n6), (math.clamp(math.ceil(n1 / v8 + v9), 1, n6))
end

return getVisibleTileRange
