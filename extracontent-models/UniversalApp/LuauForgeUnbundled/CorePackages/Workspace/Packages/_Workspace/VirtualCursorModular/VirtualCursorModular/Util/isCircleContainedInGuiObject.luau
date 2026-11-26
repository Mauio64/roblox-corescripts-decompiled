return function(p2, p3, data): boolean
	local v5 = 0.5 * data.AbsoluteSize
	local v6 = p2 - (data.AbsolutePosition + v5)

	local magnitude = v6.Magnitude
	local v7 = math.atan2(v6.Y, v6.X) - math.rad(data.AbsoluteRotation)
	local v8 = magnitude * Vector2.new(math.cos(v7), (math.sin(v7)))

	return -v5.X <= v8.X - p3 and v5.X >= v8.X + p3 and -v5.Y <= v8.Y - p3 and v5.Y >= v8.Y + p3
end
