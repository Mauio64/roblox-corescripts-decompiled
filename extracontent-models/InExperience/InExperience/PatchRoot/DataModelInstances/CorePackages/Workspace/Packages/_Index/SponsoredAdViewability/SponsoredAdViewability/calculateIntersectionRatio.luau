local function calculateIntersectionRatio(vector2: Vector2, vector2_2: Vector2, p)
	local v = vector2_2.X * vector2_2.Y

	if v <= 0 then
		return 0
	end

	local v2 = vector2 + vector2_2

	local v3 = math.max(0, p.min.X - vector2.X) + math.max(0, v2.X - p.max.X)
	local v4 = math.max(0, p.min.Y - vector2.Y) + math.max(0, v2.Y - p.max.Y)

	local v5 = vector2_2.X - v3
	local v6 = vector2_2.Y - v4

	if v5 <= 0 or v6 <= 0 then
		return 0
	end

	return v5 * v6 / v
end

return calculateIntersectionRatio
