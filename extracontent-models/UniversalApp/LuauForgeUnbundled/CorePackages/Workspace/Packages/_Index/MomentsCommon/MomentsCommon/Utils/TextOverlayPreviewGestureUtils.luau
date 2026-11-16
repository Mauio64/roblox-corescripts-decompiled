return {
	getTouchLineAngleDegrees = function(list)
		if #list < 2 then
			return nil
		end

		local v6 = list[2] - list[1]
		return (math.deg((math.atan2(v6.Y, v6.X))))
	end,
	getTouchRotationStepDegrees = function(p2, p3)
		return (p3 - p2 + 90) % 180 - 90
	end,
	touchGestureStartsOnOverlay = function(list, p2, p3): boolean
		if #list < 2 then
			return false
		end

		local v6 = (list[1] + list[2]) / 2
		return v6.X >= p2.X - 64
			and v6.X <= p2.X + p3.X + 64
			and v6.Y >= p2.Y - 64
			and v6.Y <= p2.Y + p3.Y + 64
	end
}
