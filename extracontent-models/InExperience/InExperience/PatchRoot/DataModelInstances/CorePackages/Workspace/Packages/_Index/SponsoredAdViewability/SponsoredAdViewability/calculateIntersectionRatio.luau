local function calculateIntersectionRatio(vector2: Vector2, vector2_2: Vector2, t1: {[any]: any}) -- line: 8
	local v5 = vector2_2.X * vector2_2.Y

	if v5 <= 0 then
		return 0
	end

	local v6 = vector2 + vector2_2
	local v7 = math.max(0, t1.min.X - vector2.X) + math.max(0, v6.X - t1.max.X)
	local v8 = math.max(0, t1.min.Y - vector2.Y) + math.max(0, v6.Y - t1.max.Y)
	local v9 = vector2_2.X - v7
	local v10 = vector2_2.Y - v8

	if v9 <= 0 or v10 <= 0 then
		return 0
	end

	return v9 * v10 / v5
end

return calculateIntersectionRatio
