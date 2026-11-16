local function readDenseRange(p: number, callback, p2: number, p3: number)
	local v = math.max(1, p2)
	local v2 = math.max(0, math.min(p, p3) - v + 1)
	local denseRange = table.create(v2)

	for i = 1, v2 do
		denseRange[i] = callback(v + i - 1)
	end

	return denseRange
end

return readDenseRange
