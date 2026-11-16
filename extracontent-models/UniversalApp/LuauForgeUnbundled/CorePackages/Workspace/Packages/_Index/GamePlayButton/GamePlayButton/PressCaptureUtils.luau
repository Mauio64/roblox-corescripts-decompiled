return {
	isPointInsideBounds = function(p2, p3, p4): boolean
		return p2.X >= p3.X and p2.X <= p3.X + p4.X and p2.Y >= p3.Y and p2.Y <= p3.Y + p4.Y
	end,
	getInputPosition = function(p2)
		return Vector2.new(p2.Position.X, p2.Position.Y)
	end,
	isPressInput = function(p2): boolean
		return p2.UserInputType == Enum.UserInputType.MouseButton1
			or p2.UserInputType == Enum.UserInputType.Touch
	end
}
