local function isPointWithinBounds(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2) -- line: 1
	return math.clamp(vector2.X, vector2_2.X, vector2_2.X + vector2_3.X) == vector2.X and math.clamp(vector2.Y, vector2_2.Y, vector2_2.Y + vector2_3.Y) == vector2.Y
end

return isPointWithinBounds
