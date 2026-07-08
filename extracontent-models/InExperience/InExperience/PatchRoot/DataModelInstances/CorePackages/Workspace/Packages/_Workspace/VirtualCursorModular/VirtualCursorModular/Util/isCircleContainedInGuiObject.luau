return function(vector2: Vector2, n1: number, p1) -- line: 3
	local v4 = 0.5 * p1.AbsoluteSize
	local v5 = vector2 - (p1.AbsolutePosition + v4)
	local Magnitude = v5.Magnitude
	local v7 = math.atan2(v5.Y, v5.X) - math.rad(p1.AbsoluteRotation)
	local v8 = Magnitude * Vector2.new(math.cos(v7), (math.sin(v7)))

	return -v4.X <= v8.X - n1 and (v4.X >= v8.X + n1 and (-v4.Y <= v8.Y - n1 and v4.Y >= v8.Y + n1))
end
