local function calculateIntersectionRatio(p2, p3, p4)
	local v5 = p3.X * p3.Y

	if v5 <= 0 then
		return 0
	end

	local v6 = p2 + p3

	local v7 = math.max(0, p4.min.X - p2.X) + math.max(0, v6.X - p4.max.X)
	local v8 = math.max(0, p4.min.Y - p2.Y) + math.max(0, v6.Y - p4.max.Y)

	local v9 = p3.X - v7
	local v10 = p3.Y - v8

	if v9 <= 0 or v10 <= 0 then
		return 0
	end

	return v9 * v10 / v5
end

return calculateIntersectionRatio
