local PressCaptureUtils = {}

function PressCaptureUtils.isPointInsideBounds(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2): boolean
	return vector2.X >= vector2_2.X
		and vector2.X <= vector2_2.X + vector2_3.X
		and vector2.Y >= vector2_2.Y
		and vector2.Y <= vector2_2.Y + vector2_3.Y
end

function PressCaptureUtils.getInputPosition(p)
	return Vector2.new(p.Position.X, p.Position.Y)
end

function PressCaptureUtils.isPressInput(p): boolean
	return p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch
end

return PressCaptureUtils
