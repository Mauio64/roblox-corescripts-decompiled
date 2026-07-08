return {
	isPointInsideBounds = function(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2) -- line: 1
		return vector2.X >= vector2_2.X and (vector2.X <= vector2_2.X + vector2_3.X and (vector2.Y >= vector2_2.Y and vector2.Y <= vector2_2.Y + vector2_3.Y))
	end,
	getInputPosition = function(p1) -- line: 8
		return Vector2.new(p1.Position.X, p1.Position.Y)
	end,
	isPressInput = function(p2) -- line: 12
		return p2.UserInputType == Enum.UserInputType.MouseButton1 or p2.UserInputType == Enum.UserInputType.Touch
	end
}
