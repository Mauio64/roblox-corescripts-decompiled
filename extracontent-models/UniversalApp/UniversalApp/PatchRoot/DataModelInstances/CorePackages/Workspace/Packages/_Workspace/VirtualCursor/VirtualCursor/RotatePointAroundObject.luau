local function RotatePointAroundObject(vector2: Vector2, p1) -- line: 3
	local v4 = p1.AbsolutePosition + p1.AbsoluteSize / 2

	return Vector2.new(math.cos((math.rad(p1.AbsoluteRotation))) * (vector2 - v4).Magnitude + v4.X, math.sin((math.rad(p1.AbsoluteRotation))) * (vector2 - v4).Magnitude + v4.Y)
end

return RotatePointAroundObject
