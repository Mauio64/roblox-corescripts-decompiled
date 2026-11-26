return {
	clampBetween0And1 = function(value)
		if math.abs(value) < 0.001 then
			return 0, false
		end

		if math.abs(value - 1) < 0.001 then
			return 1, false
		end

		if value >= 0 and value <= 1 then
			return value, false
		end

		return math.clamp(value, 0, 1), true
	end
}
