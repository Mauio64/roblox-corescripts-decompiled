return function(vector2: Vector2, p: number, data): boolean
	local v = 0.5 * data.AbsoluteSize
	local v2 = vector2 - (data.AbsolutePosition + v)

	local magnitude = v2.Magnitude
	local v3 = math.atan2(v2.Y, v2.X) - math.rad(data.AbsoluteRotation)
	local v4 = magnitude * Vector2.new(math.cos(v3), (math.sin(v3)))

	return -v.X <= v4.X - p and v.X >= v4.X + p and -v.Y <= v4.Y - p and v.Y >= v4.Y + p
end
