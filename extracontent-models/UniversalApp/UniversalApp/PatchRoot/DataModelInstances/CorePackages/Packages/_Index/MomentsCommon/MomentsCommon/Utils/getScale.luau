local function getScale(vector2: Vector2, vector2_2: Vector2, p)
	if vector2.X == 0 or vector2.Y == 0 or vector2_2.X == 0 or vector2_2.Y == 0 then
		return 1
	end

	local v = vector2.X / vector2.Y
	local v2 = vector2_2.X / vector2_2.Y
	local v3

	if (p == Enum.ScaleType.Fit) == (v < v2) then
		v3 = vector2.X
	else
		v3 = vector2.Y * v2
	end

	return v3 / 1280
end

return getScale
