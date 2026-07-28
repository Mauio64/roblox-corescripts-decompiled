local function getCenterScrollOffset(n1: number, n2: number, n3: number, n4: number) -- line: 15
	if n4 <= 0 then
		return nil
	end

	local v6 = math.max(0, n1 + n2 * 0.5 - n4 * 0.5)

	if math.abs(v6 - n3) < 1 then
		return nil
	end

	return v6
end

return getCenterScrollOffset
