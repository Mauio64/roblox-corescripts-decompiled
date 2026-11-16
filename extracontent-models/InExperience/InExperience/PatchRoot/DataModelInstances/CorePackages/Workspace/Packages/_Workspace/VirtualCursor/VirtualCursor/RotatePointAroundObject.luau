local function RotatePointAroundObject(vector2: Vector2, data)
	local v = data.AbsolutePosition + data.AbsoluteSize / 2
	return Vector2.new(
		math.cos((math.rad(data.AbsoluteRotation))) * (vector2 - v).Magnitude + v.X,
		math.sin((math.rad(data.AbsoluteRotation))) * (vector2 - v).Magnitude + v.Y
	)
end

return RotatePointAroundObject
