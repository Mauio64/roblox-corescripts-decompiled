local function getCropSize(vector2: Vector2, vector2_2: Vector2) -- line: 1
	if vector2.X == 0 or (vector2.Y == 0 or vector2_2.X == 0 or vector2_2.Y == 0) then
		return UDim2.fromScale(1, 1)
	end

	local v4 = vector2.X / vector2.Y
	local v5 = vector2_2.X / vector2_2.Y

	if v5 < v4 then
		return UDim2.fromScale(1, v4 / v5)
	end

	return UDim2.fromScale(v5 / v4, 1)
end

return getCropSize
