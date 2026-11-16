local function getFitSize(vector2: Vector2, vector2_2: Vector2)
	if vector2.X == 0 or vector2.Y == 0 or vector2_2.X == 0 or vector2_2.Y == 0 then
		return UDim2.fromScale(1, 1)
	end

	local v = vector2.X / vector2.Y
	local v2 = vector2_2.X / vector2_2.Y

	if v < v2 then
		return UDim2.fromScale(1, v / v2)
	end

	return UDim2.fromScale(v2 / v, 1)
end

return getFitSize
