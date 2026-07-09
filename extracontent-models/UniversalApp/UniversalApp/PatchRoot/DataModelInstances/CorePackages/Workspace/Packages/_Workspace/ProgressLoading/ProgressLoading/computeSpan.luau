local function computeSpan(n1: number, n2: number, n3: number, n4: number?, n5: number?) -- line: 1
	local v7 = n5 or 0
	local v8 = n1 - n3 * n2 * 2

	if n4 then
		v8 = math.min(v8, n4 * n2)
	end

	return (math.max(v8, v7))
end

return computeSpan
