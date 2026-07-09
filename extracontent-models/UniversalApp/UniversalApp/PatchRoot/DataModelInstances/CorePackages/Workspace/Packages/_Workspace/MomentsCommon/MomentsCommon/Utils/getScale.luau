local function getScale(vector2: Vector2, vector2_2: Vector2, p1) -- line: 3
	if vector2.X == 0 or (vector2.Y == 0 or vector2_2.X == 0 or vector2_2.Y == 0) then
		return 1
	end

	local v5 = vector2.X / vector2.Y
	local v6 = vector2_2.X / vector2_2.Y

	return ((if p1 == Enum.ScaleType.Fit ~= (v5 < v6) then vector2.Y * v6 else vector2.X)) / 1280
end

return getScale
