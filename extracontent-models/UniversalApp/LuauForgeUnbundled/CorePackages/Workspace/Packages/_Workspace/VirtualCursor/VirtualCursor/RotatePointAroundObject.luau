local function RotatePointAroundObject(p2, data)
	local v5 = data.AbsolutePosition + data.AbsoluteSize / 2
	return Vector2.new(
		math.cos((math.rad(data.AbsoluteRotation))) * (p2 - v5).Magnitude + v5.X,
		math.sin((math.rad(data.AbsoluteRotation))) * (p2 - v5).Magnitude + v5.Y
	)
end

return RotatePointAroundObject
